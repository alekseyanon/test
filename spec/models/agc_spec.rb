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


  describe '#names' do
    let(:agc) { Agc.make! }
    it 'returns a chain of relation ids with names' do
      agc.names.should == {1 => 'Россия', 2 => "Ленинградская область", 3 => "Санкт-Петербург"}
    end
  end

  describe '.most_precise_enclosing' do
    let!(:big_square_poly) { to_poly to_nodes [[0, 0], [0, 50], [50, 50], [50, 0], [0, 0]] }
    let!(:triangle_poly) {       to_poly to_nodes [[10, 10], [20, 20], [30, 10], [10, 10]] }
    let!(:inner_triangle_poly) { to_poly to_nodes [[16, 15], [20, 19], [24, 15], [16, 15]] }
    let!(:id_to_name) { {1 => {name: 'big_square',     geom: big_square_poly.geom},
                         2 => {name: 'triangle',       geom: triangle_poly.geom},
                         3 => {name: 'inner_triangle', geom: inner_triangle_poly.geom}} }
    let!(:agcs) { [[1],
                   [1, 2, 3],
                   [1, 3], #malformed agc, just for the test
                   [1, 2]].map { |relation_ids| Agc.create relations: relation_ids } }

    before do
      make_relations id_to_name
    end


    it 'returns the longest agc containing input geometry' do
      Agc::most_precise_enclosing(Geo::factory.point(20, 17)).should == agcs[1]
      Agc::most_precise_enclosing(inner_triangle_poly.geom).should == agcs[1]
      Agc::most_precise_enclosing(triangle_poly.geom).should == agcs[3]
    end
  end
end
