# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "LandmarkDescriptions", js: true, type: :request do

  self.use_transactional_fixtures = false

  before :all do
    setup_db_cleaner
    @user = User.make!

    Osm::Node.make!
    load_categories
  end

  after :all do
    DatabaseCleaner.clean
  end

  it 'has JS function get_object()' do
    ld = LandmarkDescription.make!
    visit root_path
    page.execute_script("get_object(#{ld.id}, 1, function(data){test_object = data});")
    sleep 3
    page.evaluate_script('test_object["title"]').should == ld.title
    page.evaluate_script('test_object["body"]').should_not == ld.body
    page.execute_script("get_object(#{ld.id}, 0, function(data){test_object = data});")
    sleep 3
    page.evaluate_script('test_object["title"]').should == ld.title
    page.evaluate_script('test_object["body"]').should == ld.body
  end

  context 'anonymous' do
    let!(:landmark_description){LandmarkDescription.make!(user: @user)}

    it 'renders index' do
      visit landmark_descriptions_path
      page.should have_content landmark_description.title
    end

    it 'renders show' do
      visit landmark_description_path landmark_description
      page.should have_content landmark_description.title
    end

  end

  context "LandmarkDescriptions with login" do

    before :each do
      login @user
      current_path.should == root_path
    end

    def create_new(title, tag = nil)
      visit new_landmark_description_path
      fill_in 'landmark_description_title', with: title
      find('#map').click
      #TODO cover multiple tags
      select tag, from: 'landmark_description_tag_list' if tag
      click_on 'Создать объект'
    end

    let(:title) { Faker::Lorem.words }
    let(:category) { Category.where(name: 'reservoir').first.name_ru }

    it 'creates a new landmark description' do
      create_new title, category
      page.should have_content title
      page.should have_content 'Что посмотреть?'
      page.should have_content 'Природа'
      page.should have_content 'Водохранилище'
    end

    let(:new_title){ Faker::Lorem.words }
    let(:new_category) { Category.where(name: 'dolphinarium').first.name_ru }

    it 'edits existing landmark descriptions' do
      create_new title, category
      visit landmark_description_path LandmarkDescription.last
      click_on 'редактировать описание'
      fill_in 'landmark_description_title', with: new_title
      select new_category, from: 'landmark_description_tag_list'
      click_on 'Применить изменения'
      wait_until(10){ page.should have_content new_title }
      page.should_not have_content title
      # see db/seeds/categories.yml
      page.should have_content 'Что посмотреть?'
      page.should have_content 'Природа'
      page.should have_content 'Водохранилище'
      page.should have_content 'Чем заняться?'
      page.should have_content 'Развлечения'
      page.should have_content 'Дельфинарий'
    end



    it 'voting system exsist' do
      create_new title, category
      visit landmark_description_path LandmarkDescription.last
      page.should have_selector('.votes')
      page.find('.up-vote').should have_content '0'
      page.find('.down-vote').should have_content '0'
    end

    it 'make vote for the LandmarkDescription' do
      create_new title, category
      visit ld_path = (landmark_description_path LandmarkDescription.last)
      page.find('#vote-up-reservoir').click
      page.find('.up-vote').should have_content '1'
      page.find('.down-vote').should have_content '0'
      visit ld_path
      page.find('.rate').should have_content '1'
      page.find('#vote-down-reservoir').click
      page.find('.up-vote').should have_content '0'
      page.find('.down-vote').should have_content '1'
      visit ld_path
      page.find('.rate').should have_content '0'
    end
  end

  context "landmark description search" do

    before :each do
      visit search_landmark_descriptions_path
    end

    def ld(tag_list, latlon)
      LandmarkDescription.make! tag_list: tag_list, describable: to_landmark(latlon), geom: to_point(latlon)
    end

    let!(:bar){ ld 'bar', [30.34, 59.93] }
    let!(:cafe){ ld 'cafe', [30.341, 59.931] }
    let!(:fishhouse){ ld 'dolphinarium', [30.342, 59.932] }
    let!(:hata){ ld 'apartment', [30.343, 59.933] }

    it 'can be ordered by rating' do
      login @user
      visit landmark_description_path ld = LandmarkDescription.last
      page.find('#vote-up-apartment').click
      page.find('.up-vote').should have_content '1'
      page.find('.down-vote').should have_content '0'
      get '/landmark_descriptions.json?query%5Bsort_by%5D=rate'
      resp = JSON.parse(response_from_page.to_s)
      resp[0]['id'].should == ld.id
    end

    it 'searches for landmarks' do
      #pending 'wait for upgrade to new poltergeist'
      ### TODO find a way to avoid this 'visit ...' hack
      visit search_landmark_descriptions_path
      js_click('.search-category_all')
      page.find("#searchResults").should have_content 'food'
      page.find("#searchResults").should have_content 'bar'
      page.find("#searchResults").should have_content 'cafe'

      page.find("#searchResults").should have_content 'activities'
      page.find("#searchResults").should have_content 'dolphinarium'
    end

    it 'refines search results on query change' do
      ### TODO find a way to avoid this 'visit ...' hack
      visit search_landmark_descriptions_path
      js_click('.search-category_activities')
      ### Click on 'activities' tab
      #page.find('.search-category_activities').click

      page.find("#searchResults").should_not have_content 'food'
      page.find("#searchResults").should_not have_content 'bar'
      page.find("#searchResults").should_not have_content 'cafe'

      page.find("#searchResults").should have_content 'activities'
      page.find("#searchResults").should have_content 'dolphinarium'

      ### Click on 'food' tab
      #page.find('.search-category_food').click
      js_click('.search-category_food')

      page.find("#searchResults").should have_content 'food'
      page.find("#searchResults").should have_content 'bar'
      page.find("#searchResults").should have_content 'cafe'

      page.find("#searchResults").should_not have_content 'activities'
      page.find("#searchResults").should_not have_content 'dolphinarium'

      #page.find('.search-category_all').click
      js_click('.search-category_all')
      page.fill_in 'mainSearchFieldInput', with: 'apartment'
      click_on "mainSearchButton"

      wait_until(10){ page.find("#searchResults").should have_content 'lodging' }
      page.find("#searchResults").should have_content 'apartment'
      page.find("#searchResults").should_not have_content 'food'
      page.find("#searchResults").should_not have_content 'bar'
      page.find("#searchResults").should_not have_content 'cafe'
    end
  end
end

