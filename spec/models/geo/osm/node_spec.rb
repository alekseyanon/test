require 'spec_helper'

describe Geo::Osm::Node do
  subject { described_class.make }
  it { should be_valid }
  it { should validate_presence_of :id }
  it { should validate_presence_of :geom }

  describe ".in_poly" do
    it 'returns nodes of a particular polygon' do
      nodes = [[10,10], [20,20], [30,30]].map do |x,y|
        Geo::Osm::Node.make!(geom: Geo::factory.point(x, y))
      end

      poly = Geo::Osm::Poly.make! nodes: nodes.map(&:id)
      Geo::Osm::Node.in_poly(poly).should =~ nodes
    end
  end

  describe ".within_radius" do
    let(:triangle){ to_nodes [[10,10], [20,20], [30,10]] }

    it 'returns nodes within a specified radius of another node' do
      Geo::Osm::Node.within_radius(triangle[0], 10).should =~ triangle[0..0]
      Geo::Osm::Node.within_radius(triangle[0], 15).should =~ triangle[0..1]
      Geo::Osm::Node.within_radius(triangle[0], 20).should =~ triangle
      Geo::Osm::Node.within_radius(triangle[2], 15).should =~ triangle[1..2]
    end
  end
end
