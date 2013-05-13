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

  it 'can be attached to Event' do
    login
    e = Event.make!
    visit event_path(e)
    click_on 'Add photo'
    page.current_path.should == new_event_image_path(e)
  end

  it 'can be attached to GeoObject' do
    login
    go = GeoObject.make!(tag_list: [Category.make!.name])
    visit geo_object_path(go)
    find("a[href*='/images/new']").trigger 'click'
    save_and_open_page
    page.current_path.should == new_geo_object_image_path(go)
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
