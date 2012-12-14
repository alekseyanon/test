require 'spec_helper'

describe AreaDescription do
  subject { described_class.make! }
  it_behaves_like "an abstract description"

  describe ".within_radius" do #TODO move to shared example group with landmarks and nodes altogether
    let(:polygons){ get_foursquares([[10, 10], [30, 10], [10, 30], [30, 30], [100, 100]]) }
    let!(:descriptions) { polygons.map{|poly| AreaDescription.make! describable: (Area.make! osm: poly) } }

    it 'returns areas within a specified radius of another area' do
      geom = descriptions[0].describable.osm.geom
      described_class.within_radius(geom, 10).count.should == 3
      described_class.within_radius(geom, 20).count.should == 4
      described_class.within_radius(geom, 120).count.should == 5
    end
  end

  describe '.search' do
    let!(:d){ load_descriptions }

    context 'for plain text queries' do
      it_behaves_like "text search"
    end

    context 'for combined geospatial and text queries' do
      it_behaves_like "combined search" do
        let(:osm){ get_foursquares([[10, 10]])[0] }
      end
    end
  end
end
