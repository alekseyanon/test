# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "LandmarkDescriptions", js: true, type: :request do
  self.use_transactional_fixtures = false

  def login
    @user = User.make!
    visit profile_path type: 'traveler'
    fill_in 'user_session[email]', with: @user.email
    fill_in 'user_session[password]', with: @user.password
    click_on 'Войти'
  end

  before :all do
    #http://stackoverflow.com/questions/5433690/capybaraselemium-how-to-initialize-database-in-an-integration-test-code-and-ma
    #DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation

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
  let(:category) {Category.where(name: 'reservoir').first.name_ru}

  it 'creates a new landmark description' do
    create_new title, category
    page.should have_content title
    # see db/seeds/categories.yml
    page.should have_content 'Что посмотреть?'
    page.should have_content 'Природа'
    page.should have_content 'Водохранилище'
  end

  let(:new_title){ Faker::Lorem.word }
  let(:new_category) {Category.where(name: 'dolphinarium').first.name_ru}

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

