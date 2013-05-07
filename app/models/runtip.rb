class Runtip < ActiveRecord::Base
	#Совет как добраться
  belongs_to :user
  belongs_to :geo_object
  attr_accessible :body

  validates :body, :user, :geo_object, presence: true
end
