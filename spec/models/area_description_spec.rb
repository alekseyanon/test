require 'spec_helper'

describe AreaDescription do
  subject { described_class.make! }
  it_behaves_like "an abstract description"  

  describe ".within_radius" do #TODO move to shared example group with landmarks and nodes altogether
    let(:polygons){ get_foursquares([[10, 10], [30, 10], [10, 30], [30, 30], [100, 100]]) }
    let(:descriptions) do 
      polygons.each do |poly|        
        a = Area.new
        a.osm = poly
        a.save!
        AreaDescription.make! describable: a
      end
    end

    it 'returns nodes within a specified radius of another node' do
      descriptions
      described_class.within_radius(described_class.first.describable.osm.geom, 10).count.should == 3
      described_class.within_radius(described_class.first.describable.osm.geom, 20).count.should == 4
      described_class.within_radius(described_class.first.describable.osm.geom, 120).count.should == 5
    end
  end

  describe '.search' do
    let!(:d){
      File.open("#{Rails.root}/db/seeds/landmark_descriptions.yml"){|f| YAML.load f.read}.map{|yld|
        ld = described_class.make! yld.slice(:title, :body)
        ld.tag_list += yld[:tags] if yld[:tags] #TODO move to blueprints
        ld.save
        ld
      }
    }

    context 'for plain text queries' do
      it_behaves_like "text search"      
    end

    context 'for combined geospatial and text queries' do
      it 'performs full text search for landmarks in around coordinates provided' do
        polygon = get_foursquares([[10, 10]])[0]
        d[0].describable.osm = polygon
        d[0].describable.save        
        described_class.search(text: "fishing", geom: polygon.geom, r: 1).should == [d[0]]
        described_class.search(text: "fishing", geom: polygon.geom, r: 100).should == [d[0], d[2], d[3]]
      end
    end
  end



end
