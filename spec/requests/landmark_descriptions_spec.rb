# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "LandmarkDescriptions", js: true, type: :request do

  self.use_transactional_fixtures = false

  context "LandmarkDescriptions with login" do
    before :all do
      setup_db_cleaner

      Osm::Node.make!
      load_categories
    end

    before :each do
      login
      current_path.should == root_path
    end

    after :all do
      DatabaseCleaner.clean
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
      # see db/seeds/categories.yml
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
      str = "\#0_#{@ld.id}_1"
      visit landmark_description_path @ld
      page.should have_selector('.user-rating')
      page.should have_selector(str)
    end

    it "rating is changed" do
      create_new title, category
      @ld = LandmarkDescription.last
      str = "\#0_#{@ld.id}_1"
      visit landmark_description_path @ld
      page.find('.jStar').click
      visit landmark_description_path @ld
      page.should_not have_selector(str)
      page.should have_content 'Ваша оценка'
    end
  end

  context "landmark description search" do
    before :all do
      setup_db_cleaner

      Osm::Node.make!
      load_categories
    end

    before :each do
      login
      current_path.should == root_path
      visit search_landmark_descriptions_path
    end

    after :all do
      DatabaseCleaner.clean
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
      # page.find('.search-filter-tabs dt:nth-child(9)').click
      page.find('.search-filter-tabs dt:nth-child(1)').click

      page.find("#search-results").should have_content 'bar'
      page.find("#search-results").should have_content 'food'
      page.find("#search-results").should have_content 'food'
      page.find("#search-results").should have_content 'cafe'
      page.find("#search-results").should have_content 'activities'
      page.find("#search-results").should have_content 'dolphinarium'
      page.find("#search-results").should have_content 'entertainment'
      page.find("#search-results").should have_content 'apartment'
      page.find("#search-results").should have_content 'lodging'
    end

    it 'refines search results on query change' do
      ### Click on food tab
      page.find('.search-filter-tabs dt:nth-child(9)').click
      page.find("#search-results").should have_content 'bar'
      page.find("#search-results").should have_content 'food'
      page.find("#search-results").should have_content 'cafe'
      page.find("#search-results").should_not have_content 'dolphinarium'
      page.find("#search-results").should_not have_content 'entertainment'
      page.find("#search-results").should_not have_content 'activities'
      page.find("#search-results").should_not have_content 'apartment'
      page.find("#search-results").should_not have_content 'lodging'
      page.find("#search-results").should_not have_content 'apartment'

      ### Click on 'lodging'
      page.find('.search-filter-tabs dt:nth-child(7)').click
      page.find("#search-results").should_not have_content 'bar'
      page.find("#search-results").should_not have_content 'cafe'
      page.find("#search-results").should_not have_content 'food'

      page.find("#search-results").should have_content 'apartment'
      page.find("#search-results").should have_content 'lodging'
      page.find("#search-results").should have_content 'apartment'

      page.fill_in 'searchField', with: 'apartment'
      click_on "Найти"
      page.find("#search-results").should_not have_content 'bar'
      page.find("#search-results").should_not have_content 'cafe'
      page.find("#search-results").should_not have_content 'food'
      page.find("#search-results").should_not have_content 'entertainment'
      page.find("#search-results").should_not have_content 'activities'

      page.find("#search-results").should have_content 'lodging'
      page.find("#search-results").should have_content 'apartment'
    end
  end
end

