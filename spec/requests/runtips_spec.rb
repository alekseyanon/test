#encoding : utf-8
require 'spec_helper'

describe "Runtips", js: true, type: :request do

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

  it 'make votes for runtip' do
    rt = Runtip.make!
    visit geo_object_path(rt.geo_object)
    page.find("#runtip_#{rt.id}").find('#vote-up').click
    page.find("#runtip_#{rt.id}").find('.up-vote').should have_content '1'
    page.find("#runtip_#{rt.id}").find('.down-vote').should have_content '0'
  end

end
