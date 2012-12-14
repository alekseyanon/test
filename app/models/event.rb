class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :landmark
  attr_accessible :body, :scheldule, :title, :duration
  validates :title, presence: true
  validates_associated :user, :landmark

  after_create :generate_occasions

  def generate_occasions
    #TODO
  end
end
