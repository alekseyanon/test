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
end