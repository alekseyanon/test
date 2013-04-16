require 'spec_helper'

describe LandmarkDescription do
  subject { described_class.make! }
  it_behaves_like "an abstract description"

  describe ".within_radius" do #TODO move to shared example group with landmarks and nodes altogether
    let(:triangle)     { to_points [[10, 10], [20, 20], [30, 10]] }
    let(:landmarks)    { to_landmarks triangle }
    let(:descriptions) { landmarks_to_descriptions landmarks }
    it 'returns nodes within a specified radius of another node' do
      described_class.within_radius(triangle[0], 10).should =~ descriptions[0..0]
      described_class.within_radius(triangle[0], 15).should =~ descriptions[0..1]
      described_class.within_radius(triangle[0], 20).should =~ descriptions
      described_class.within_radius(triangle[2], 15).should =~ descriptions[1..2]
    end
  end

  describe ".objects_nearby" do
    let(:triangle)     { to_points [[10, 10], [20, 10], [30, 10]] }
    let(:landmarks)    { to_landmarks triangle }
    let(:descriptions) { landmarks_to_descriptions landmarks }

    it 'returns objects near another' do
      descriptions[0].objects_nearby(15).should =~ [descriptions[1]]
    end

  end

  describe '.search' do
    before(:all){ load_categories }

    let!(:d){ load_descriptions }

    context 'for plain text queries' do
      it_behaves_like 'text search against title and body'
      it_behaves_like 'text search against title and body and tags'
    end

    context 'for combined geospatial and text queries' do
      it_behaves_like "combined search" do
        let(:osm){ Osm::Node.make! geom: Geo::factory.point(10, 10) }
      end
    end

    context 'for faceted combined geospatial and text queries' do
      it_behaves_like "combined faceted search" do
        let(:osm){ Osm::Node.make! geom: Geo::factory.point(10, 10) }
      end
    end
  end
end
