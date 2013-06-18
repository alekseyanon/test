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
    count = GeoObject.all.count
    visit root_path
    page.find('#objectsTotal').should have_content count.to_s
  end

  it 'should show chronicle content' do
    g = GeoObject.make!
    visit root_path
    find('.chronicle').should have_content g.title
  end

  it 'chronicle should have pagination' do
    g = GeoObject.make!
    (CHRONICLE_PAGINATION_ITEMS + 1).times { GeoObject.make! }
    visit root_path
    find('.chronicle').should_not have_content g.title
    find('.fetch-results__button a').click
    find('.chronicle').should have_content g.title
  end

  it 'chronicle can response with objects json' do
    prev_obj = GeoObject.all.count
    (CHRONICLE_PAGINATION_ITEMS + 1).times { GeoObject.make! }
    visit api_chronicles_show_path format: :json
    objects = JSON.parse page.find('pre').text
    objects['items'].count.should == CHRONICLE_PAGINATION_ITEMS
    objects['items'].first['id'].should == GeoObject.last.id
    visit api_chronicles_show_path offset: objects['offset'], format: :json
    objects = JSON.parse page.find('pre').text
    objects['items'].count.should == (prev_obj >= (CHRONICLE_PAGINATION_ITEMS-1) ? CHRONICLE_PAGINATION_ITEMS : 1 + prev_obj)
  end
end
