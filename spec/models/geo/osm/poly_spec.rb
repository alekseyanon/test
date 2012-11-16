require 'spec_helper'

describe Geo::Osm::Poly do
  subject { described_class.make }
  it { should be_valid }
  it { should validate_presence_of :id }
  it { should validate_presence_of :tags }
  it { should validate_presence_of :nodes }

  def to_points(crd)
    crd.map{|x,y| Geo::Osm::Node.make!(geom: Geo::factory.point(x, y))}
  end

  let(:triangle){           to_points [[10,10], [20,20], [30,10]] }
  let(:inner_triangle){     to_points [[16,15], [20,19], [24,15]] }
  let(:rightmost_triangle){ to_points [[40,10], [50,20], [60,10]] }

  let(:triangle_poly){ Geo::Osm::Poly.make! nodes: triangle.map(&:id) }
  let(:inner_triangle_poly){ Geo::Osm::Poly.make! nodes: inner_triangle.map(&:id) }
  let(:rightmost_triangle_poly){ Geo::Osm::Poly.make! nodes: rightmost_triangle.map(&:id) }

  describe '#poly' do
    it 'instantiates RGeo polygon' do
      triangle_poly.poly.exterior_ring.points.should include *triangle.map(&:geom)
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
  end

  describe '#touches?' do
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
