#encoding: utf-8
require 'spec_helper'

describe Api::GeoObjectsController do

  describe "GET 'nearby'" do
    it 'render returns objects nearby another' do
      fake_object = GeoObject.make!
      radius = 123
      GeoObject.should_receive(:find).with(fake_object.id.to_s).and_return(fake_object)
      GeoObject.any_instance.should_receive(:objects_nearby).with(radius.to_s).and_return(fake_object)
      get :nearby, id: fake_object.id, r: radius
      response.should be_success
      response.body.should == fake_object.to_json
    end

    login_user

    it 'pushes successful search query to user\'s history' do
      GeoObject.make! title: 'превед медвед'
      expect { 
        get :index, { format: :json, query: { text: 'превед медвед' } }
      }.to change(SearchQuery, :count).by(1)
      SearchQuery.all.last.str.should == 'превед медвед'
      SearchQuery.all.last.user.should_not be_nil
    end

  end

end
