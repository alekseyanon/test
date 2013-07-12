# fun coding: UTF-8
require 'spec_helper'

describe Api::EventsController do

  describe 'GET week' do

    it 'returns events for specified date + 7 days' do
      Event.destroy_all
      events = dates_to_events [7.days.ago, 4.days.ago, 3.days.ago, 1.days.from_now, 15.days.from_now]
      get :week, date: 5.days.ago.strftime('%F')
      assigns(:events).should =~ [events[1],events[2],events[3]]
    end

  end

  describe 'GET tags' do
    it 'возвращает все теги событий в JSON' do
      tag = EventTag.make!
      get :tags
      assigns(:tags).should include(tag)
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

  describe 'GET search' do          # 0             1           2           3           4                 5
    before :all do
      Event.destroy_all
    end
    let!(:events){ dates_to_events([7.days.ago, 4.days.ago, 3.days.ago, Time.now, 1.days.from_now, 15.days.from_now]) }
    let!(:event) { Event.make!(title: 'New beautiful event', body: "This is a special test text", start_date: 50.days.from_now, tag_list: 'zzz, xxx, yyy') }

    it 'can sort results by date or rate' do
      get :search, from: 8.days.ago.strftime('%F'), to: Time.now.strftime('%F'), sort_by: 'date'
      assigns(:events).should == [events[0], events[1], events[2], events[3]]
      events[3].update_column(:rating, 3)
      events[2].update_column(:rating, 3)
      events[1].update_column(:rating, 1)
      get :search, from: 8.days.ago.strftime('%F'), to: Time.now.strftime('%F'), sort_by: 'rating'
      assigns(:events).should == [events[3], events[2], events[1], events[0]]
    end

    it 'has I will go count, I like count, sum of both' do
      get :search, text: 'beautiful'
      ev = JSON.parse(response.body, {symbolize_names: true}).first
      ev.has_key?(:rating_go).should be_true
      ev.has_key?(:rating_like).should be_true
      ev.has_key?(:rating).should be_true
    end

    it 'can search inside :from :to period' do
      get :search, from: 2.days.ago.strftime('%F'), to: 3.days.from_now.strftime('%F')
      assigns(:events).should =~ [events[3], events[4]]
    end

    it 'can search inside :from date' do
      get :search, from: 2.days.ago.strftime('%F')
      assigns(:events).should =~ [events[3], events[4], events[5], event]
    end

    it 'can search by text' do
      get :search, text: 'beautiful'
      assigns(:events).should eq([event])
    end

    it 'can search by tag_id' do
      tag = EventTag.find_by_title 'zzz'
      get :search, tag_id: tag.id
      assigns(:events).should == [event]
    end

    it 'can autocomplete by title' do
      get :autocomplete, term: 'beau'
      assigns(:events).should eq([event])
    end

    it 'can autocomplete by body' do
      get :autocomplete, term: 'speci'
      assigns(:events).should eq([event])
    end

    it 'can autocomplete by tags' do
      get :autocomplete, term: 'xxx'
      assigns(:events).should eq([event])
    end

    context 'place' do

      let(:agc) { make_sample_agus!; Agc.make!}
      let!(:future_event_with_agc){ Event.make! agc: agc, start_date: 1.month.from_now}
      let!(:past_event_with_agc){ Event.make! agc: agc, start_date: 1.month.ago}

      it 'returns future events if exists' do
        get :search, place_id: agc.agus.first
        assigns(:events).should == [future_event_with_agc]
      end

      it 'returns first event if there is only past events' do
        future_event_with_agc.destroy
        get :search, place_id: agc.agus.first
        assigns(:events).should == [past_event_with_agc]
      end

    end

  end

end
