# encoding: utf-8
require 'spec_helper'

describe Api::ChroniclesController do
  render_views
  describe 'GET show' do
    before :all do
      Event.destroy_all
      GeoObject.destroy_all
    end

    let!(:new_event) { Event.make! }
    let!(:archived_event) { Event.make! state: :archived }
    let!(:geo_object) { GeoObject.make! }

    def get_show_chronicle type = nil
      get :show, {format: :json}.merge(type ? {type: type} : {})
      JSON.parse(response.body)
    end

    it 'events only' do
      resp = get_show_chronicle('event')
      resp['items'].length.should == 1
      resp['items'][0]['type'].should == 'event'
    end

    it 'geo_objects only' do
      resp = get_show_chronicle('geo_object')
      resp['items'].length.should == 1
      resp['items'][0]['type'].should == 'geo_object'
    end

    it 'all items' do
      resp = get_show_chronicle()
      resp['items'].length.should == 2
    end
  end

end
