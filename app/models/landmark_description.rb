class LandmarkDescription < AbstractDescription
  def self.within_radius geom, r
    LandmarkDescription.within_radius_scope geom, r, 'nodes'
  end
end
