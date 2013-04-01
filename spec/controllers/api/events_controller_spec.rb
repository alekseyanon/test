require 'spec_helper'

describe Api::EventsController do

  describe 'GET week' do

    it 'returns events for specified date + 7 days' do
      events = dates_to_events [7.days.ago, 4.days.ago, 3.days.ago, 1.days.from_now, 15.days.from_now]
      get :week, date: 5.days.ago.strftime '%F'
      assigns(:events).should =~ [events[1],events[2],events[3]]
    end

  end

  describe 'GET tags' do
    it 'возвращает все теги событий в JSON' do
      tag = EventTag.make!
      get :tags
      assigns(:tags).should eq([tag])
      expect(response).to be_success
    end

    it 'теги имеют атрибуты: id, title, system' do
      tag = EventTag.make!
      get :tags
      tag_hash = JSON.parse(response.body, {symbolize_names: true}).first
      tag_hash.has_key?(:system).should be_true
      tag_hash.has_key?(:id).should be_true
      tag_hash.has_key?(:title).should be_true
    end
  end

  describe 'GET search' do
    it 'without parameters it returns events for current date'
    it 'can search inside :from :to period'
    it 'can search by text'
    it 'can search by tag_id'
    it 'can search by place_id'
    it 'can sort results by date or rate'
    it 'paginate search results'
  end

end
