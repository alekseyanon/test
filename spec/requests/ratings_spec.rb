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

  let!(:user_to_vote){ User.make! }
  let!(:user_without_vote){ User.make! }
  let!(:geo_object){ GeoObject.make!(user: user_without_vote, tag_list: 'tester') }
  let!(:image){ Image.make!(user: user_without_vote) }
  let!(:review){ Review.make!(user: user_without_vote) }
  let!(:comment){ Comment.make!(user: user_without_vote) }

  it 'changed after vote for review' do
    login(user_to_vote)
    visit review_path(review)
    page.find('#vote-up').click
    page.find('.up-vote').should have_content '1'
    page.find('.down-vote').should have_content '0'
    User.find(user_without_vote.id).expert.should == 1
  end

  it 'creates a new Geo Object' do
    login(user_to_vote)
    #visit new_geo_object_path
    #fill_in 'geo_object_title', with: 'test title'
    #find('#map').click
    ##TODO cover multiple tags
    #select Category.where(name: 'reservoir').first.name_ru, from: 'geo_object_tag_list', visible: false
    #click_on 'Создать объект'
    visit geo_object_path(geo_object)
    page.find('#vote-up-tester').click
    page.find('.up-vote').should have_content '1'
    page.find('.down-vote').should have_content '0'
    User.find(user_to_vote.id).discoverer.should == 1
  end
end
