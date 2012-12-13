require 'spec_helper'

describe Osm::Poly do
  subject { described_class.make }
  it { should be_valid }
  it { should validate_presence_of :id }

  let(:triangle){           to_nodes [[10,10], [20,20], [30,10], [10,10]] }
  let(:inner_triangle){     to_nodes [[16,15], [20,19], [24,15], [16,15]] }
  let(:rightmost_triangle){ to_nodes [[40,10], [50,20], [60,10], [40,10]] }

  let(:triangle_poly){ to_poly triangle }
  let(:inner_triangle_poly){ to_poly inner_triangle }
  let(:rightmost_triangle_poly){ to_poly rightmost_triangle }

  describe '#poly' do
    it 'instantiates RGeo polygon' do
      triangle_poly.geom.exterior_ring.points.should include *triangle.map(&:geom)
    end
  end

  describe '#contains?' do
    it 'determines if the polygon contains a node' do
      triangle.each do |node|
        triangle_poly.contains?(node).should be_false
      end
      triangle.each do |node|
        inner_triangle_poly.contains?(node).should be_false
      end
      inner_triangle.each do |node|
        triangle_poly.contains?(node).should be_true
      end
    end
    it 'determines if the polygon contains another polygon' do
      triangle_poly.contains?(inner_triangle_poly).should be_true
      inner_triangle_poly.contains?(triangle_poly).should be_false
    end
  end

  describe '#touches?' do
    #TODO cover two polygons touching case
    it 'determines if the polygon touches a node' do
      triangle.each do |node|
        triangle_poly.touches?(node).should be_true
      end
      inner_triangle.each do |node|
        triangle_poly.touches?(node).should be_false
      end
    end
  end

  describe '#intersects?' do
    it 'determines if the polygon contains another polygon' do
      triangle_poly.intersects?(rightmost_triangle_poly).should be_false
      triangle_poly.intersects?(inner_triangle_poly).should be_true
      inner_triangle_poly.intersects?(triangle_poly).should be_true
    end
  end
end
