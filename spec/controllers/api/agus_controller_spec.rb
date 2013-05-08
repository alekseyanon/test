# encoding: utf-8
require 'spec_helper'

describe Api::AgusController do

  describe 'GET search' do
  	it 'можно искать по названию и прямоугольнику' do
  		poly1 = 'POLYGON((10 10, 10 20, 20 20, 20 10, 10 10))'
  		poly2 = 'POLYGON((-10 -10, -10 -20, -20 -20, -20 -10, -10 -10))'
  		agu1 = Agu.make! title: 'one', geom: poly1, place: true
  		agu2 = Agu.make! title: 'two', geom: poly1, place: true
  		agu3 = Agu.make! title: 'one', geom: poly2, place: true
  		get :search, query: {geom: 'POINT(15 15)', r: 10, text: 'one'}
  		assigns(:agus).should =~ [agu1]
  		get :search, query: {bounding_box: [15,15,20,20], text: 'one'}
  		assigns(:agus).should =~ [agu1]
  	end
  end

end
