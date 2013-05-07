# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Agc do
  let(:delete_query) { id_to_name.keys.map { |n| "delete from relations where id = #{n};" }.join }

  before :all do
    drop_relations
  end

  after :all do
    drop_relations
  end


  describe '#titles' do
    let(:agc) { make_sample_agus!; Agc.make! }
    it 'returns a chain of relation ids with titles' do
      agc.titles.should == {1=>"Россия", 2=>"Ленинградская область", 3=>"Санкт-Петербург"}
    end
  end

  describe '.most_precise_enclosing' do
    let!(:big_square_poly) { to_poly to_nodes [[0, 0], [0, 50], [50, 50], [50, 0], [0, 0]] }
    let!(:triangle_poly) {       to_poly to_nodes [[10, 10], [20, 20], [30, 10], [10, 10]] }
    let!(:inner_triangle_poly) { to_poly to_nodes [[16, 15], [20, 19], [24, 15], [16, 15]] }
    let!(:agus) { [Agu.make!(id: 1, title: 'big_square', geom: big_square_poly.geom),
                   Agu.make!(id: 2, title: 'triangle',       geom: triangle_poly.geom),
                   Agu.make!(id: 3, title: 'inner_triangle', geom: inner_triangle_poly.geom)] }
    let!(:agcs) { [[1],
                   [1, 2, 3],
                   [1, 3], #malformed agc, just for the test
                   [1, 2]].map { |ids| Agc.create agus: ids } }

    it 'returns the longest agc containing input geometry' do
      Agc::most_precise_enclosing(Geo::factory.point(20, 17)).should == agcs[1]
      Agc::most_precise_enclosing(inner_triangle_poly.geom).should == agcs[1]
      Agc::most_precise_enclosing(triangle_poly.geom).should == agcs[3]
    end
  end
end
