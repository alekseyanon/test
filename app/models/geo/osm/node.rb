class Geo::Osm::Node < ActiveRecord::Base
  # http://wiki.openstreetmap.org/wiki/Osmosis/PostGIS_Setup
  # for details see osmosis/script/pgsnapshot_schema_0.6.sql
  set_table_name "nodes"
  set_rgeo_factory_for_column(:geom, RGeo::Geographic.spherical_factory(:srid => 4326))
  attr_accessible :geom, :tags
  serialize :tags, ActiveRecord::Coders::Hstore

  validates :id, :geom, :presence => true
end
