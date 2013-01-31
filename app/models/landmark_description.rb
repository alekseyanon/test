class LandmarkDescription < AbstractDescription

	has_many :ratings
  attr_accessor :xld, :yld
  attr_accessible :xld, :yld

  def self.within_radius geom, r
    LandmarkDescription.within_radius_scope geom, r, 'nodes'
  end

  def average_rating
  	self.ratings.average(:value).to_f
  end

  def user_vote_present?(userid)
  	self.ratings.where(user_id: userid).include?(userid)
  end
end
