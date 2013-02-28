class Area < GeoUnit
  def self.within_radius geom, r
    Area.within_radius_scope geom, r, 'ways'
  end
end
