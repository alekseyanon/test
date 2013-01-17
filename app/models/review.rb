class Review < ActiveRecord::Base
  attr_accessible :title, :body 
  belongs_to :user
  belongs_to :reviewable, polymorphic: true
  has_many :images, as: :imageable
end
