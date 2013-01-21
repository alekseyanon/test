# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Events", js: true, type: :request do
  include RspecHelper
  self.use_transactional_fixtures = false

  before :all do
    setup_db_cleaner
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
    fill_in 'event_geom', with: 'POINT(10 10)'
    click_on 'Save'
  end

  let(:title) { Faker::Lorem.sentence }  
  let(:body)  { Faker::Lorem.sentence 2}
  let(:event) { Event.make! repeat_rule: 'weekly', title: title, start_date: Time.now}

  it 'creates a new event' do
    create_new title, body
    page.should have_content title
    page.should have_content body
  end

  it 'has repeats in future' do
    event
    visit events_path
    page.should have_content title
    click_on "Позже"
    page.should have_content title
    click_on "Раньше"
    click_on "Раньше"
    page.should have_no_content title
  end

  it 'searchable' do
    event
    visit search_events_path
    fill_in 'text', with: title
    click_on 'Search'
    page.should have_content title
    fill_in 'text', with: title
    fill_in 'date', with: 1.day.from_now.strftime('%F')
    click_on 'Search'
    page.should have_no_content title
  end
  
end

