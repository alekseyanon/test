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

  let(:review){ Review.make! }
  let(:body)  { Faker::Lorem.sentence 2}  

  it 'creates a new comment' do
    visit review_path(review)
    fill_in 'comment_body', with: body
    click_on 'Создать Comment'
    page.should have_content body
  end

end
