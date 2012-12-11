require 'spec_helper'

describe Area do
  subject { described_class.make }
  it { should be_valid }
  it { should belong_to :osm }

  describe ".within_radius" do

    it 'returns Areas within a specified radius of another Area' do
      described_class.within_radius(described_class.first.osm.geom, 10).count.should == 3
    end
  end
end
