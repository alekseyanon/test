class AreaDescription < AbstractDescription
  def self.within_radius geom, r
    LandmarkDescription.within_radius_scope geom, r, 'ways'
  end
end
