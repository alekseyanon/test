# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Reviews" do

  self.use_transactional_fixtures = false

  before :all do
    setup_db_cleaner
  end

  before :each do
    login
    current_path.should == root_path
  end

  after :all do
    DatabaseCleaner.clean
  end

  let(:review){ Review.make! }
  let(:body)  { Faker::Lorem.sentence 5}
  let(:comment)  { Comment.make! }

  it 'creates a new comment' do
    visit review_path(review)
    fill_in 'comment_body', with: body
    click_on 'Отправить'
    page.should have_content body
  end

  it 'can answer another comment' do
    visit new_review_comment_path(comment.commentable, parent_id: comment.id)
    fill_in 'comment_body', with: body
    click_on 'Отправить'
    page.should have_selector('.pic_comments__chid_comments .pic_comments__chid_comments')
    page.should have_content body
  end

end
