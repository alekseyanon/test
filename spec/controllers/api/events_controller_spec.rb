require 'spec_helper'

describe Api::EventsController do

  describe 'GET week' do
    it 'success' do
      get :week
      expect(response).to be_success
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
