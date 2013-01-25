class LmRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :landmark_description
  attr_accessible :value
end
