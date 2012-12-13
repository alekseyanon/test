class Landmark < GeoUnit
  def self.within_radius geom, r
    Landmark.within_radius_scope geom, r, 'nodes'
  end
end
