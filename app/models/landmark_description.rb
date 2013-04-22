class LandmarkDescription < AbstractDescription

  has_many :ratings
  has_one :video, as: :movie_star
  attr_accessor :xld, :yld
  attr_accessible :xld, :yld

  acts_as_voteable

  def self.within_radius geom, r
    LandmarkDescription.within_radius_scope geom, r, 'nodes'
  end

  def average_rating
  	self.ratings.average(:value).to_f
  end

  def user_vote_present?(userid)
  	!self.ratings.where(user_id: userid).empty?
  end
end
