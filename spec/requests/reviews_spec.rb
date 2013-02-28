require 'spec_helper'

describe "Reviews", js: true, type: :request do

  self.use_transactional_fixtures = false

  before :all do
    setup_db_cleaner
    load_categories
  end

  before :each do
    login
    current_path.should == root_path
  end

  after :all do
    DatabaseCleaner.clean
  end

  def create_new(title, body)
    visit new_landmark_description_review_path(landmark_description)
    fill_in 'review_title', with: title
    fill_in 'review_body', with: body
    click_on 'Save'
  end

  let!(:landmark_description){ LandmarkDescription.make! }
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

end
