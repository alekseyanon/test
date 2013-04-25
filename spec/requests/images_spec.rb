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
    visit new_event_path
    page.should have_selector '.add_fields'
    page.find('.add_fields').click
    page.should have_selector "input[id^='event_images_attributes_']"
    page.should have_selector '.add_fields'
  end

  it 'fields appear on geo_object created form' do
    visit new_event_path
    page.should have_selector '.add_fields'
    page.find('.add_fields').click
    page.should have_selector "input[id^='geo_object_images_attributes_']"
    page.should have_selector '.add_fields'
  end

  it 'can be added to the GeoObject' do
    login
    go = GeoObject.make!
    visit edit_geo_object_path(go)
    page.find('.add_fields').click
    ImageUploader.any_instance.stub(:download!)
    uploader = ImageUploader.new(go, Image.make!(imageable: go))
    uploader.store!(File.open("#{Rails.root}/spec/fixtures/images/fishing/toon376.gif"))
    click_on 'Применить изменения'
    current_path.should == geo_object_path(go)
    go.images.count.should > 0
  end

  it 'are displayed on the object page' do
    go = GeoObject.make!#( images: [Image.make!])
    go.images.make!
    visit geo_object_path(go)
    page.should have_selector('.object_image')
  end

  it 'are displayed on the event page' do
    e = Event.make!#( images: [Image.make!])
    e.images.make!
    visit event_path(e)
    page.should have_selector('.event_image')
  end
end
