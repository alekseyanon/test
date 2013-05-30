class Runtip < ActiveRecord::Base
	#Совет как добраться
  belongs_to :user
  belongs_to :geo_object
  attr_accessible :body

  has_many :complaints, as: :complaintable

  validates :body, :user, :geo_object, presence: true

  acts_as_voteable
end
