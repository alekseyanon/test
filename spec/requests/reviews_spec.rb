require 'spec_helper'

describe "Reviews" do
  include RspecHelper
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

end
