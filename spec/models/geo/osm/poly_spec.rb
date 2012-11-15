require 'spec_helper'

describe Geo::Osm::Poly do
  subject { described_class.make }
  it { should be_valid }
  it { should validate_presence_of :id }
  it { should validate_presence_of :tags }
  it { should validate_presence_of :nodes }

  describe "#poly" do
    it 'instantiates RGeo polygon' do
      nodes = [[10,10], [20,20], [30,30]].map do |x,y|
        Geo::Osm::Node.make!(geom: Geo::factory.point(x, y))
      end

      poly = Geo::Osm::Poly.make! nodes: nodes.map(&:id)
      poly.poly.exterior_ring.points.should include *nodes.map(&:geom)
    end
  end

end
