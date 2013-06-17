# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Clustering do
  let!(:clusters)     { [ to_points([[10, 10], [10, 11], [10, 12]]),
                         to_points([[20, 10], [20, 11], [20, 12]]) ]}
  let!(:geo_objects_clusters)  { clusters.map{|c| to_geo_objects c} }

  it '.from_chain' do
    Clustering.from_chain( GeoObject.within_radius(GeoObject.first.geom, 15), 2 )[0].should == {geom: clusters[0][1], member_ids: geo_objects_clusters[0].map(&:id)}
  end
end
