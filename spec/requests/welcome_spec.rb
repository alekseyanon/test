# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Welcome", js: true, type: :request do

  self.use_transactional_fixtures = false

  before :all do
    setup_db_cleaner
  end

  after :all do
    DatabaseCleaner.clean
  end

  it 'should show objects count number' do
    GeoObject.make!
    visit root_path
    page.find('#objectsTotal').should have_content '1'
  end

  it 'should show chronicle content' do
    g = GeoObject.make!
    visit root_path
    find('.chronicle').should have_content g.title
  end

  it 'chronicle should have pagination' do
    g = GeoObject.make!
    11.times { GeoObject.make! }
    visit root_path
    find('.chronicle').should_not have_content g.title
    find('.fetch-results__button a').click
    find('.chronicle').should have_content g.title
  end

  it 'chronicle can response with objects json' do
    prev_obj = GeoObject.all.count
    11.times { GeoObject.make! }
    visit api_chronicles_show_path format: :json
    objects = JSON.parse page.find('pre').text
    objects.count.should == 10
    objects.first['id'].should == GeoObject.last.id
    visit api_chronicles_show_path page: '1', format: :json
    objects = JSON.parse page.find('pre').text
    objects.count.should == (prev_obj >= 9 ? 10 : 1 + prev_obj)
  end
end
