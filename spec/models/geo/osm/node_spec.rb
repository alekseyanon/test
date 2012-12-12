require 'spec_helper'

describe Osm::Node do
  subject { described_class.make }
  it { should be_valid }
  it { should validate_presence_of :id }
  it { should validate_presence_of :geom }

  describe ".within_radius" do
    let(:triangle){ to_nodes [[-10,-10], [-20,-20], [-30,-10]] }

    it 'returns nodes within a specified radius of another node' do
      described_class.within_radius(triangle[0], 10).should =~ triangle[0..0]
      described_class.within_radius(triangle[0], 15).should =~ triangle[0..1]
      described_class.within_radius(triangle[0], 20).should =~ triangle
      described_class.within_radius(triangle[2], 15).should =~ triangle[1..2]
    end
  end
end
