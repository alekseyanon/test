class LandmarkDescription < AbstractDescription

	has_many :ratings
  attr_accessor :xld, :yld
  attr_accessible :xld, :yld

  def self.within_radius geom, r
    LandmarkDescription.within_radius_scope geom, r, 'nodes'
  end

  def css_id
  	[self.ratings.average(:value).to_f, self.id].join("_")
  end

  def user_vote_present?(userid)
  	!self.ratings.pluck(:user_id).include?(userid)
  end
end
