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

  describe '.search' do
    let!(:d){ load_landmark_descriptions }

    context 'for plain text queries' do
      it_behaves_like 'text search'
    end

    context 'for combined geospatial and text queries' do
      it 'performs full text search for landmarks in around coordinates provided' do
        point = Geo::factory.point(10, 10)
        d[0].describable.osm = Osm::Node.make! geom: point
        d[0].describable.save
        described_class.search(text: "fishing", geom: point, r: 1).should == [d[0]]
        described_class.search(text: "fishing", geom: point, r: 100).should == [d[0], d[2], d[3]]
      end
    end
  end
end
