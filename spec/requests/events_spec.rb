# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Events", js: true, type: :request do
  self.use_transactional_fixtures = false

  def login
    @user = User.make!
    visit profile_path type: 'traveler'
    fill_in 'user_session[email]', with: @user.email
    fill_in 'user_session[password]', with: @user.password
    click_on 'Войти'
  end

  before :all do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation
  end

  before :each do
    login
    current_path.should == root_path
  end

  after :all do
    DatabaseCleaner.clean
  end

  def create_new(title, body)
    visit new_event_path
    fill_in 'event_title', with: title
    fill_in 'event_body', with: body
    click_on 'Save'
  end

  let(:title) { Faker::Lorem.word }  
  let(:body)  { Faker::Lorem.sentence 2}

  it 'creates a new event' do
    create_new title, body
    page.should have_content title
    page.should have_content body
  end
  
end

