class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :landmark_description
  attr_accessible :value

  ### Метод для поиска оценки LandmarkDecsription
  def self.with_landmark_id(landmark_description_id)
  	where(landmark_description_id: landmark_description_id).first
  end
end
