require 'spec_helper'

describe Api::ObjectsController do

  describe "GET 'nearby'" do

    it 'returns objects nearby another' do
      o1 = GeoObject.make! geom: 'POINT(1 1)', title: 1
      o2 = GeoObject.make! geom: 'POINT(2 2)', title: 2
      o3 = GeoObject.make! geom: 'POINT(10 10)', title: 3
      o4 = GeoObject.make! geom: 'POINT(0 0)', title: 4
      get :nearby, id: o1.id, r: 5
      expect(assigns(:objects)).to match_array([o2, o4])
      # assigns(:objects).should =~ [ld2, ld4]
    end

  end

end
