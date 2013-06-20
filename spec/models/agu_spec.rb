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

  it_behaves_like 'search within radius'
end
