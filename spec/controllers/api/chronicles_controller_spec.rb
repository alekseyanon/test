# encoding: utf-8
require 'spec_helper'

describe Api::ChroniclesController do
  render_views
  describe 'GET show' do
    before :all do
      Event.destroy_all
      GeoObject.destroy_all
      Event.make!
      GeoObject.make!
    end

    after :all do
      DatabaseCleaner.clean
    end

    def get_show type = nil
      get :show, {format: :json}.merge( type ? {type: type} : {})
      JSON.parse(response.body)
    end

    it 'events only' do
      resp = get_show('event')
      resp['items'].length.should == 1
      resp['items'][0]['type'].should == 'event'
    end

    it 'geo_objects only' do
      resp = get_show('geo_object')
      resp['items'].length.should == 1
      resp['items'][0]['type'].should == 'geo_object'
    end

    it 'all items' do
      resp = get_show()
      resp['items'].length.should == 2
    end
  end

end
