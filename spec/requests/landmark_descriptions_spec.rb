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

    let(:title) { Faker::Lorem.word }
    let(:category) { Category.where(name: 'reservoir').first.name_ru }

    it 'creates a new landmark description' do
      create_new title, category
      page.should have_content title
      page.should have_content 'Что посмотреть?'
      page.should have_content 'Природа'
      page.should have_content 'Водохранилище'
    end

    let(:new_title){ Faker::Lorem.word }
    let(:new_category) { Category.where(name: 'dolphinarium').first.name_ru }

    it 'edits existing landmark descriptions' do
      create_new title, category
      visit landmark_description_path LandmarkDescription.last
      click_on 'Edit'
      fill_in 'landmark_description_title', with: new_title
      select new_category, from: 'landmark_description_tag_list'
      click_on 'Применить изменения'
      sleep 5
      page.should_not have_content title
      page.should have_content new_title
      # see db/seeds/categories.yml
      page.should have_content 'Что посмотреть?'
      page.should have_content 'Природа'
      page.should have_content 'Водохранилище'
      page.should have_content 'Чем заняться?'
      page.should have_content 'Развлечения'
      page.should have_content 'Дельфинарий'
    end

    it 'check rating' do
      create_new title, category
      @ld = LandmarkDescription.last
      visit landmark_description_path @ld
      page.should have_selector(".landmark-descrition-rating", :'data-average' => '0.0')
      page.should have_selector('.user-rating')
      page.should have_selector('.jStar')
    end

    it "rating is changed" do
      create_new title, category
      @ld = LandmarkDescription.last
      visit landmark_description_path @ld
      page.should have_selector(".landmark-descrition-rating", :'data-average' => '0.0')
      page.find('.jStar').click
      visit landmark_description_path @ld
      page.should have_selector(".landmark-descrition-rating", :'data-id' => @ld.id)
      page.should have_content 'Ваша оценка'
    end
  end

  context "landmark description search" do

    before :each do
      visit search_landmark_descriptions_path
    end

    def ld(tag_list, latlon)
      LandmarkDescription.make! tag_list: tag_list, describable: to_landmark(latlon)
    end

    let!(:bar){ ld 'bar', [30.34, 59.93] }
    let!(:cafe){ ld 'cafe', [30.341, 59.931] }
    let!(:fishhouse){ ld 'dolphinarium', [30.342, 59.932] }
    let!(:hata){ ld 'apartment', [30.343, 59.933] }

    it 'searches for landmarks' do
      ### TODO: Придумать корректное решение
      ### Это хак пока не придумал как его исправить
      ### Без него у меня почему то не работает (((
      page.find('.search-type-tab-cell:first-child .search-type-tab').click

      page.find("#search-results").should have_content 'food'
      page.find("#search-results").should have_content 'bar'
      page.find("#search-results").should have_content 'cafe'

      page.find("#search-results").should have_content 'activities'
      page.find("#search-results").should have_content 'dolphinarium'
    end

    it 'refines search results on query change' do
      ### Click on 'activities' tab
      page.find('.search-type-tab-cell:nth-child(3) .search-type-tab').click

      page.find("#search-results").should_not have_content 'food'
      page.find("#search-results").should_not have_content 'bar'
      page.find("#search-results").should_not have_content 'cafe'

      page.find("#search-results").should have_content 'activities'
      page.find("#search-results").should have_content 'dolphinarium'

      ### Click on 'food' tab
      page.find('.search-type-tab-cell:last-child .search-type-tab').click

      page.find("#search-results").should have_content 'food'
      page.find("#search-results").should have_content 'bar'
      page.find("#search-results").should have_content 'cafe'

      page.find("#search-results").should_not have_content 'activities'
      page.find("#search-results").should_not have_content 'dolphinarium'

      page.find('.search-type-tab-cell:first-child .search-type-tab').click
      page.fill_in 'mainSearchFieldInput', with: 'apartment'
      click_on "mainSearchButton"
      sleep 5
      page.find("#search-results").should_not have_content 'food'
      page.find("#search-results").should_not have_content 'bar'
      page.find("#search-results").should_not have_content 'cafe'

      page.find("#search-results").should have_content 'lodging'
      page.find("#search-results").should have_content 'apartment'
    end
  end
end

