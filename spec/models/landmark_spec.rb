require 'spec_helper'

describe Landmark do
  subject { described_class.make }
  it { should be_valid }

  it { should belong_to :osm }

  describe ".within_radius" do
    let(:triangle){ to_points [[10,10], [20,20], [30,10]] }
    let(:landmarks){ to_landmarks triangle }

    it 'returns nodes within a specified radius of another node' do
      described_class.within_radius(triangle[0], 10).should =~ landmarks[0..0]
      described_class.within_radius(triangle[0], 15).should =~ landmarks[0..1]
      described_class.within_radius(triangle[0], 20).should =~ landmarks
      described_class.within_radius(triangle[2], 15).should =~ landmarks[1..2]
    end
  end

  describe ".within_geom" do
    let(:triangle)     { to_points [[11,11], [19,19], [30,10]] }
    let(:landmarks)    { to_landmarks triangle }
    let(:polygon)      { get_foursquares([[  10,  10]])[0]}
    let(:polygon_empty){ get_foursquares([[ 100, 100]])[0]}
    let(:polygon_one)  { get_foursquares([[  25,   5]])[0]}

    it 'returns landmarks within a specified geom' do      
      described_class.within_geom(polygon.geom).should =~ landmarks[0..1]      
      described_class.within_geom(polygon_empty.geom).count.should == 0
      described_class.within_geom(polygon_one.geom).count.should == 1
    end
  end

end