class Landmark < GeoUnit
  
  def self.within_radius geom, r
    Landmark.within_radius_scope geom, r, 'nodes'
  end

  scope :within_geom, ->(geom) do
    joins( "INNER JOIN nodes ON nodes.id = geo_units.osm_id").
        where "ST_Contains(ST_GeomFromText('#{geom}', #{Geo::SRID}), nodes.geom)"
  end

end
