class LandmarkDescription < AbstractDescription

  attr_accessor :xld, :yld
  attr_accessible :xld, :yld

  def self.within_radius geom, r
    LandmarkDescription.within_radius_scope geom, r, 'nodes'
  end
end
