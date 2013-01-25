class LandmarkDescription < AbstractDescription

	has_many :lm_ratings
  attr_accessor :xld, :yld
  attr_accessible :xld, :yld

  def self.within_radius geom, r
    LandmarkDescription.within_radius_scope geom, r, 'nodes'
  end

  def average_rating
  	(self.lm_ratings.count > 0) ? self.lm_ratings.sum(:value) / self.lm_ratings.count.to_f : 0
  end

  def css_id
  	[self.average_rating, self.id, 1].join("_")
  end

  def user_vote_present?(userid)
  	!self.lm_ratings.pluck(:user_id).include?(userid)
  end
end
