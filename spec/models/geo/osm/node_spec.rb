require 'spec_helper'

describe Geo::Osm::Node do
  subject { described_class.make }
  it { should be_valid }
  it { should validate_presence_of :id }
  it { should validate_presence_of :geom }

  describe ".in_poly" do
    it 'returns nodes of a particular polygon' do
      nodes = [[10,10], [20,20], [30,30]].map do |x,y|
        Geo::Osm::Node.make!(geom: RGeo::Geographic.spherical_factory(:srid => 4326).point(x, y))
      end

      poly = Geo::Osm::Poly.make! nodes: nodes.map(&:id)
      Geo::Osm::Node.in_poly(poly).should == nodes
    end
  end
end
