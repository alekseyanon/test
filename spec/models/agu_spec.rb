# encoding: utf-8
require 'spec_helper'

describe Agu do
  it 'можно искать места по радиусу, координате и названию' do
    agu1 = Agu.make! geom: 'POLYGON((0 0, 1 0, 0 1, 0 0))'
    agu2 = Agu.make! geom: 'POLYGON((0 0, 1 0, 0 1, 0 0))'
    agu3 = Agu.make! title: agu2.title, geom: 'POLYGON((100 80, 101 80, 100 81, 100 80))'
    Agu.search({geom: 'POINT(0 0)', r: 5, text: agu2.title}).should == [agu2]
  end

  it '.agcs' do
  	agc1 = Agc.make! agus: [1]
  	agc2 = Agc.make! agus: [1, 2]
  	agc3 = Agc.make! agus: [2, 3]
  	agu = Agu.make! id: 1
  	agu.agcs.should =~ [agc1, agc2]
  end

  it "makes rectangle representation of AGU and scales it" do
    x1, y1, x2, y2 = 100, 80, 101, 81
    agu = Agu.make! geom: "POLYGON ((103.7393871 51.7505388, 103.7418097 51.7567121, 103.7454718 51.7623615, 103.7580921 51.7601297, 103.7720082 51.7553868, 103.7708251 51.7505737, 103.7678954 51.7449926, 103.7576977 51.7400737, 103.7393871 51.7505388))"
    calculated_coords = agu.to_map_bounds
    # Check that it makes rectangle from polygon
    calculated_coords.flatten.size.should == 4
    calculated_coords[0][0].should == 104.776780971
    calculated_coords[0][1].should == 52.257474437
    calculated_coords[1][0].should == 104.809728282
    calculated_coords[1][1].should == 52.279985115
  end

  it_behaves_like 'search within radius'
end
