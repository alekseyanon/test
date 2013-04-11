class AreaDescription < AbstractDescription
  def self.within_radius geom, r
    AreaDescription.within_radius_for_area_scope geom, r, 'ways'
  end
end
