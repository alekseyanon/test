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
  end

  context 'search page' do

    def ld(tag_list, latlon)
      LandmarkDescription.make! tag_list: tag_list, describable: to_landmark(latlon)
    end

    let!(:bar){ ld 'bar', [30.34, 59.93] }
    let!(:cafe){ ld 'cafe', [30.341, 59.931] }
    let!(:fishhouse){ ld 'dolphinarium', [30.342, 59.932] }
    let!(:hata){ ld 'apartment', [30.343, 59.933] }

    before :each do
      visit search_landmark_descriptions_path
    end

    it 'searches for landmarks' do
      page.should have_content 'bar,food'
      page.should have_content 'cafe,food'
      page.should have_content 'dolphinarium,entertainment,activities'
      page.should have_content 'apartment,lodging'
    end

    it 'refines search results on query change' do
      page.check 'food'
      page.should have_content 'bar'
      page.should have_content 'food'
      page.should have_content 'cafe'
      page.should_not have_content 'dolphinarium'
      page.should_not have_content 'entertainment'
      page.should_not have_content 'activities'
      page.should_not have_content 'apartment'
      page.should_not have_content 'lodging'
      page.should_not have_content 'apartment'

      page.check 'lodging'
      page.check 'activities'
      page.uncheck 'food'
      page.should_not have_content 'bar'
      page.should_not have_content 'cafe'
      page.should_not have_content 'food'
      page.should have_content 'dolphinarium'
      page.should have_content 'entertainment'
      page.should have_content 'activities'
      page.should have_content 'apartment'
      page.should have_content 'lodging'
      page.should have_content 'apartment'

      page.fill_in 'text', with: 'apartment'
      page.should_not have_content 'bar'
      page.should_not have_content 'cafe'
      page.should_not have_content 'food'
      page.should_not have_content 'entertainment'
      page.should_not have_content 'activities'
      page.should_not have_content 'apartment'
      page.should have_content 'lodging'
      page.should have_content 'apartment'
    end
  end
end

