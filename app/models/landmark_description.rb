class LandmarkDescription < AbstractDescription

  attr_accessor :xld, :yld
  attr_accessible :xld, :yld, :rating, :pnt

  acts_as_voteable

  def self.within_radius geom, r
    LandmarkDescription.within_radius_scope geom, r, 'nodes'
  end

  #def rating
  #  (self.votes_for.to_f / self.leaf_categories.count.to_f).round
  #end

end
