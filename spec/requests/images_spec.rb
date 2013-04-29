# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Images', js: true, type: :request do
  self.use_transactional_fixtures = false

  before :all do
    setup_db_cleaner
  end

  after :all do
    DatabaseCleaner.clean
  end

  it 'fields appear on event created form' do
    login
    visit new_event_path
    page.should have_selector '.add_fields'
    page.find('.add_fields').click
    page.should have_selector "input[id^='event_images_attributes_']"
    page.should have_selector '.add_fields'
  end

  it 'fields appear on geo_object created form' do
    login
    visit new_geo_object_path
    page.should have_selector '.add_fields'
    page.find('.add_fields').click
    page.should have_selector "input[id^='geo_object_images_attributes_']"
    page.should have_selector '.add_fields'
  end

  it 'are displayed on the object page' do
    go = GeoObject.make!(tag_list: [Category.make!.name])
    Image.make!(imageable: go)
    visit geo_object_path(go)
    page.should have_selector('.object_image')
  end

  it 'are displayed on the event page' do
    e = Event.make!
    Image.make!(imageable: e)
    visit event_path(e)
    page.should have_selector('.event_image')
  end
end
