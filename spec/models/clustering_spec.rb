# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Clustering do
  let!(:clusters)     { [ to_points([[10, 10], [10, 11], [10, 12]]),
                          to_points([[20, 10], [20, 11], [20, 12]]) ]}
  let!(:geo_objects_clusters)  { clusters.map{|c| to_geo_objects c} }

  let(:bb) { [9,9,20,20] }

  let(:resulting_clusters) { [0,1].map{|cn| { geom: clusters[cn][1],
                                              member_ids: geo_objects_clusters[cn].map(&:id) }} }

  it '.from_chain' do
    if ENV['TDDIUM']
      puts 'Tddium cant use binary libs, skipping'
    else
      chain = GeoObject.search bounding_box: bb
      result = Clustering.from_chain chain, 2
      result.should == resulting_clusters
      [0,1].each do |cn|
        result[cn][:geom].should == resulting_clusters[cn][:geom]
        result[cn][:member_ids].should =~ resulting_clusters[cn][:member_ids]
      end
    end
  end

  it 'should be called from searcheable' do
    if ENV['TDDIUM']
      puts 'Tddium cant use binary libs, skipping'
    else
      result = GeoObject.search bounding_box: bb, clusters: 2
      [0,1].each{|cn| result[cn].geom.should == resulting_clusters[cn][:geom]}
    end
  end
end
