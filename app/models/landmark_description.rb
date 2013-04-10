class LandmarkDescription < AbstractDescription

  attr_accessor :xld, :yld
  attr_accessible :xld, :yld, :rating, :pnt

  acts_as_voteable

  def self.within_radius geom, r
    LandmarkDescription.within_radius_scope geom, r, 'nodes'
  end

  def average_rating
    (rate = self.rating) > 0 ? rate.round : 0
  end

end
