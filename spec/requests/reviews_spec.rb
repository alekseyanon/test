# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Reviews", js: true, type: :request do

  self.use_transactional_fixtures = false

  before :all do
    setup_db_cleaner
  end

  before :each do
    login
    page.find('#notice').should have_content('Вход в систему выполнен')
  end

  after :all do
    DatabaseCleaner.clean
  end

  def create_new(title, body)
    visit new_geo_object_review_path(geo_object)
    fill_in 'review_title', with: title
    fill_in 'review_body', with: body
    click_on 'Save'
  end

  let!(:geo_object){ GeoObject.make! }
  let(:title) { Faker::Lorem.sentence }
  let(:body)  { Faker::Lorem.sentence 2}

  it 'creates a new review' do
    create_new title, body
    page.should have_content title
    page.should have_content body
  end

  it 'voting system exsist' do
    create_new title, body
    visit review_path Review.last
    page.should have_selector('.votes')
    page.find('.up-vote').should have_content '0'
    page.find('.down-vote').should have_content '0'
  end

  it 'make vote for the review' do
    create_new title, body
    visit review_path Review.last
    page.find('#vote-up').click
    page.find('.up-vote').should have_content '1'
    page.find('.down-vote').should have_content '0'
  end

  it 'complaint system exsist' do
    create_new title, body
    visit review_path Review.last
    page.should have_selector('.complaint')
  end

  it 'make complaint for the review' do
    -> do
      r = Review.make!
      visit review_path r
      page.find('#review_complaint').click
      page.should have_selector('.complaint > form')
      fill_in 'complaint_content', with: 'test'
      click_on 'Отправить жалобу'
      current_path.should == review_path(r)
    end.should change(Complaint, :count).by(1)
  end
end
