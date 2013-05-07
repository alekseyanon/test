#encoding : utf-8
require 'spec_helper'

describe "Runtips" do

  self.use_transactional_fixtures = false

  before :all do
    setup_db_cleaner
    load_seeds
  end

  before :each do
    login
    current_path.should == root_path
  end

  after :all do
    DatabaseCleaner.clean
  end

  let(:geo_object){ GeoObject.make! }
  let(:body)  { Faker::Lorem.sentence 5}

  it 'creates a new runtip' do
    visit geo_object_path(geo_object)
    fill_in 'runtip_body', with: body
    click_on 'Создать Runtip'
    page.should have_content body
  end

end
