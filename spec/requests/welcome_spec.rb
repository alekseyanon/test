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

end
