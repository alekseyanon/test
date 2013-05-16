# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Events", js: true, type: :request do

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

  let(:title) { Faker::Lorem.sentence }
  let(:body)  { Faker::Lorem.sentence 2}
  let(:tags)  { 'aaa, bbb, ccc' }
  let(:start_date) {Time.now}
  let(:end_date) {1.days.from_now}
  let(:event) { Event.make! repeat_rule: 'weekly', title: title, start_date: start_date, end_date: end_date }

  def fill_in_new
    visit new_event_path
    fill_in 'event_title', with: title
    fill_in 'event_body', with: body
    fill_in 'event_geom', with: 'POINT(10 10)'
    fill_in 'event_tag_list', with: tags
    select  'single', from: 'event_repeat_rule'
  end


  def create_new
    fill_in_new
    click_on 'Save'
  end

  context 'as guest' do
    it 'cant edit event' do
      e = Event.make!
      visit edit_event_path(e)
      uri = URI.parse(current_url)
      "#{uri.path}#{uri.query}".should == root_path
    end
  end

  it 'should show event list' do
    pending
    #event
    #visit events_path
    create_new title, body, tags
    item = page.find('.smorodina-item')
    item.should have_content title
    item.should have_content tags
    item.should have_content "#{Time.now.strftime('%e %B')} - #{1.day.from_now.strftime('%e %B')}"
  end

  it 'creates a new event' do
    create_new
    page.should have_content title
    page.should have_content body
    page.should have_content 'aaa'
    page.should have_content 'bbb'
    page.should have_content 'ccc'
  end

  it 'has repeats in future' do
    pending 'not implemented'
    event
    visit events_path
    page.should have_content title
    click_on "Позже"
    page.should have_content title
    click_on "Раньше"
    click_on "Раньше"
    page.should have_no_content title
  end

  it 'searchable' do
    pending 'not implemented'
    event
    visit search_events_path
    fill_in 'text', with: title
    click_on 'Search'
    page.should have_content title
    fill_in 'text', with: title
    fill_in 'date', with: 1.day.from_now.strftime('%F')

    # TODO: Хак, как обойти не знаю, без него у меня не отработало
    page.execute_script("$('#ui-datepicker-div').css('display', 'none');")

    click_on 'Search'
    page.should have_no_content title
  end

  it 'add field for load image' do
    pending 'not implemented'
    visit new_event_path
    page.should have_selector('a.add_fields')
    page.should_not have_selector("input[type='file']")
    click_on 'add image'
    page.should have_selector("input[type='file']")
  end

  let(:event_with_image) { Event.make! images: [Image.make!]}
  it 'event with image' do
    visit event_path event_with_image
    page.should have_selector(".event_image")
    page.should have_selector(".votes")
    page.find('.up-vote').should have_content '0'
    page.find('.down-vote').should have_content '0'
  end

  it 'vote for image' do
    visit event_path event_with_image
    page.find('#vote-up').click
    page.find('.up-vote').should have_content '1'
    page.find('.down-vote').should have_content '0'
  end

  it 'event with multiple youtube videos' do
    fill_in_new
    2.times{ click_on 'add video' }
    inputs = page.all :css, 'input[id^="video_url"]'
    inputs[0].set 'youtube.com/watch?v=DZGINaRUEkU'
    inputs[1].set 'youtube.com/watch?v=4wTLjEqj5Xk'
    page.execute_script "$('form#new_event').submit()" #totally a hack. click_button('Save') fails for no visible reason
    sleep 2
    visit event_path Event.last
    page.should have_selector 'iframe[name="DZGINaRUEkU"]'
    page.should have_selector 'iframe[name="4wTLjEqj5Xk"]'
  end
end

