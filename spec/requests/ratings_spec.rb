# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Ratings', js: true, type: :request do
  self.use_transactional_fixtures = false

  before :all do
    setup_db_cleaner
    load_seeds
  end

  after :all do
    DatabaseCleaner.clean
  end

  before :each do
    login(user_to_vote)
  end

  let!(:user_to_vote){ User.make! }
  let!(:user_without_vote){ User.make! }
  let!(:review){ Review.make!(user: user_without_vote) }

  it 'expert can be changed' do
    visit review_path(review)
    page.find('#vote-up').click
    page.find('.up-vote').should have_content '1'
    page.find('.down-vote').should have_content '0'
    User.find(user_without_vote.id).expert.should == 1.3
  end

  it 'discoverer can be changed' do
    go = GeoObject.make! tag_list: 'reservoir'
    visit geo_object_path(go)
    page.find('#vote-up-reservoir').click
    page.find('.up-vote').should have_content '1'
    page.find('.down-vote').should have_content '0'
    User.find(go.user_id).discoverer.should == 140
  end

  it 'photographer can be changed' do
    e = Event.make!
    img = Image.make!(imageable: e)
    visit event_path(e)
    page.should have_selector('.event_image')
    page.find('#vote-up').click
    page.find('.up-vote').should have_content '1'
    page.find('.down-vote').should have_content '0'
    User.find(img.user_id).photographer.should == 1.2
  end

  it 'commentator can be changed' do
    pending 'while voting without positive and negative numbers'
    visit review_path(review)
    fill_in 'comment_body', with: 'abra cadabra'
    click_on 'Ответить'
    comment = Comment.last
    page.find('pic_comments__comment').find('button.icon-thumbs-up').click
    page.find('pic_comments__comment').find('.up-vote').should have_content '1'
    page.find('pic_comments__comment').find('.down-vote').should have_content '0'
    User.find(comment.user_id).commentator.should == 1.08
  end

end
