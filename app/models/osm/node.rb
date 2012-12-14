class Osm::Node < ActiveRecord::Base
  # http://wiki.openstreetmap.org/wiki/Osmosis/PostGIS_Setup
  # for details see osmosis/script/pgsnapshot_schema_0.6.sql
  self.table_name = 'nodes'
  has_one :geo_unit, as: :osm
  set_rgeo_factory_for_column(:geom, Geo::factory)
  attr_accessible :geom, :tags
  serialize :tags, ActiveRecord::Coders::Hstore

  validates :id, :geom, :presence => true

  def latlon
    [geom.y, geom.x] #TODO figure out what's really latitude and what is longitude
  end

  scope :in_poly, ->(poly_id) do
    #{:conditions => ['id in (?)', Geo::Osm::Poly.find(poly_id).nodes]}
    where 'id = any(select unnest(nodes) from ways where id = ?)', poly_id
  end

  scope :within_radius, ->(other,r) do
    where "ST_DWithin(geom, ST_GeomFromText('#{other.geom}', #{Geo::SRID}), #{r})"
  end

  scope :with_landmarks, joins('inner join geo_units on geo_units.osm_id = nodes.id')

  scope :closest_node, ->(x,y) do
    order("geom <-> ST_Geomfromtext('POINT (#{x} #{y})', #{Geo::SRID})").limit(2)
  end
end
