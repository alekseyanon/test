# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Videos', js: true, type: :request do
  self.use_transactional_fixtures = false

  before :all do
    setup_db_cleaner
  end

  after :all do
    DatabaseCleaner.clean
  end

  it 'able to attach to Event' do
    login
    e = Event.make!
    visit event_path(e)
    click_on 'Add video'
    page.current_path.should == new_event_video_path(e)
    fill_in 'you_tude_url', with: 'http://www.youtube.com/watch?v=EYApe6Cs11A'
    click_on 'Save'
    visit event_path(e)
    page.should have_selector('iframe[name="EYApe6Cs11A"]')
  end
end
