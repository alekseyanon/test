# fun coding: UTF-8
require 'spec_helper'

describe GeoObject do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should belong_to :user }

  it 'have agc after create' do
    make_sample_agus!
    Agc.make!
    obj = GeoObject.make! geom: 'POINT(0 0)', agc: nil
    obj.agc.should_not be_nil
  end

  describe "geometry requests" do #TODO move to shared example group with landmarks and nodes altogether
    let(:triangle)     { to_points [[10, 10], [20, 20], [30, 10]] }
    let(:descriptions) { to_geo_objects triangle }

    it '.bounding_box' do
      described_class.bounding_box(15,15,40,40).should =~ [descriptions[1]]
    end

    it '.within_radius' do
      described_class.within_radius(triangle[0], 10).should =~ descriptions[0..0]
      described_class.within_radius(triangle[0], 15).should =~ descriptions[0..1]
      described_class.within_radius(triangle[0], 20).should =~ descriptions
      described_class.within_radius(triangle[2], 15).should =~ descriptions[1..2]
    end

    it '.objects_nearby' do
      descriptions[0].objects_nearby(15).should =~ [descriptions[1]]
    end

  end

  describe '.search' do
    # TODO REVIEW maybe create only needed categories?
    before(:all){ load_seeds }

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

    context 'for queries with agc_id' do
      let(:agc1){ Agc.make! agus: [3,4] }
      let(:agc2){ Agc.make! agus: [5] }

      it 'searches GeoObject with agc_id' do
        GeoObject.make!(geom: Geo::factory.point(10, 10), agc: agc1, title: 'Кафе').save!
        GeoObject.make!(geom: Geo::factory.point(9, 9),   agc: agc1, title: 'Кафе').save!
        GeoObject.make!(geom: Geo::factory.point(10, 10), agc: agc2, title: 'Кафе').save!
        described_class.search(agc_id: agc2.id, title: 'Кафе').length.should == 1
        described_class.search(agc_id: agc1.id, title: 'Кафе').length.should == 2
      end
    end

  end
end
