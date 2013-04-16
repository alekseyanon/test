require 'spec_helper'

describe Api::ObjectsController do

  describe "GET 'nearby'" do

    it 'returns objects nearby another' do
      n1 = Osm::Node.make! geom: 'POINT(1 1)'
      l1 = Landmark.make! osm: n1
      ld1 = LandmarkDescription.make! describable: l1, title: 1  # Наш технический долг касательно БД
      n2 = Osm::Node.make! geom: 'POINT(2 2)'
      l2 = Landmark.make! osm: n2
      ld2 = LandmarkDescription.make! describable: l2, title: 2  # дает о себе знать даже здесь
      n3 = Osm::Node.make! geom: 'POINT(10 10)'
      l3 = Landmark.make! osm: n3
      ld3 = LandmarkDescription.make! describable: l3, title: 3  # в тестах
      n4 = Osm::Node.make! geom: 'POINT(0 0)'
      l4 = Landmark.make! osm: n4
      ld4 = LandmarkDescription.make! describable: l4, title: 4
      get :nearby, id: ld1.id, r: 5
      # binding.pry
      expect(assigns(:objects)).to match_array([ld2, ld4])
      # assigns(:objects).should =~ [ld2, ld4]
    end

  end

end
