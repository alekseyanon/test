class Geo::Osm::Node < ActiveRecord::Base
  # http://wiki.openstreetmap.org/wiki/Osmosis/PostGIS_Setup
  # for details see osmosis/script/pgsnapshot_schema_0.6.sql
  set_table_name "nodes"
  set_rgeo_factory_for_column(:geom, Geo::factory)
  attr_accessible :geom, :tags
  serialize :tags, ActiveRecord::Coders::Hstore

  validates :id, :geom, :presence => true

  scope :in_poly, lambda {|poly_id|
    #{:conditions => ['id in (?)', Geo::Osm::Poly.find(poly_id).nodes]}
    {:conditions => ['id = any(select unnest(nodes) from ways where id = ?)', poly_id]}
  }
end
