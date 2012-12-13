require 'spec_helper'
require 'rake'

describe Area do
  subject { described_class.make }
  it { should be_valid }
  it { should belong_to :osm }
 
  describe ".within_radius" do
    let(:node){Osm::Node.make! id: 2}
    let(:polygons){ get_foursquares([[10, 10], [30, 10], [10, 30], [30, 30], [100, 100]]) }
    let(:areas) do
      polygons.each do |poly|
        a = Area.new
        a.osm = poly
        a.save!
      end
    end

    it 'returns Areas within a specified radius of another Area' do 
      areas
      described_class.within_radius(described_class.first.osm.geom, 10).count.should == 3
      described_class.within_radius(described_class.first.osm.geom, 20).count.should == 4
      described_class.within_radius(described_class.first.osm.geom, 120).count.should == 5
    end
  end
end
