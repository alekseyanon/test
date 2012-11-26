require 'spec_helper'

#TODO cover weighting
#TODO cover multi-word search
describe LandmarkDescription do
  subject { described_class.make! }
  it_behaves_like "an article"
  it { should belong_to :landmark }

  describe ".within_radius" do #TODO move to shared example group with landmarks and nodes altogether
    let(:triangle) { to_points [[10, 10], [20, 20], [30, 10]] }
    let(:landmarks) { to_landmarks triangle }
    let(:descriptions) { landmarks_to_descriptions landmarks }

    it 'returns nodes within a specified radius of another node' do
      described_class.within_radius(triangle[0], 10).should =~ descriptions[0..0]
      described_class.within_radius(triangle[0], 15).should =~ descriptions[0..1]
      described_class.within_radius(triangle[0], 20).should =~ descriptions
      described_class.within_radius(triangle[2], 15).should =~ descriptions[1..2]
    end
  end

  describe '.search' do
    let!(:d){
      File.open("#{Rails.root}/db/seeds/landmark_descriptions.yml"){|f| YAML.load f.read}.map{|yld|
        ld = described_class.make! yld.slice(:title, :body)
        ld.landmark.tag_list += yld[:tags] if yld[:tags] #TODO move to blueprints
        ld.landmark.save
        ld
      }
    }

    context 'for plain text queries' do
      it 'performs full text search against title and body' do
        #TODO add fuzzy / dictionary-based search
        described_class.search('Fishing').should =~ [d[0], d[2], d[3]]
        described_class.search('fish').should =~ [d[1], d[4]]
      end
      it 'performs full text search against title, body and tags' do
        described_class.search('net').should =~ [d[2], d[3]]
        described_class.search('gear').should =~ [d[1], d[3]]
        described_class.search('line').should =~ [d[1], d[2], d[3], d[4]]
        described_class.search('tools').should =~ [d[1], d[2], d[3], d[4]]
      end
    end

    context 'for combined geospatial and text queries' do
      it 'performs full text search for landmarks in around coordinates provided' do
        point = Geo::factory.point(10, 10)
        d[0].landmark.node = Geo::Osm::Node.make! geom: point
        d[0].landmark.save
        described_class.search(text: "fishing", geom: point, r: 1).should == [d[0]]
        described_class.search(text: "fishing", geom: point, r: 100).should == [d[0], d[2], d[3]]
      end
    end
  end
end
