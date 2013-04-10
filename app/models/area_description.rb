class AreaDescription < AbstractDescription
  def self.within_radius geom, r
    AreaDescription.within_radius_scope_for_area geom, r, 'ways'
  end
end
