class Landmark < GeoUnit
  scope :within_radius, ->(geom,r) do
    joins( "INNER JOIN nodes ON nodes.id = geo_units.osm_id").
        where "ST_DWithin(nodes.geom, ST_GeomFromText('#{geom}', #{Geo::SRID}), #{r})"
  end

  scope :closest_point, ->(x, y) do
    joins("INNER JOIN nodes ON nodes.id = geo_units.osm_id").
      order("nodes.geom <-> ST_Geomfromtext('POINT (#{x} #{y})', #{Geo::SRID})").limit(2)
  end
end
