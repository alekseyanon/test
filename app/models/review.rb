class Review < ActiveRecord::Base
  attr_accessible :title, :body 
  belongs_to :user
  belongs_to :reviewable, polymorphic: true
  has_many :images,   as: :imageable
  has_many :comments, as: :commentable

  acts_as_voteable
  
  validates :title, :body, :user, :reviewable, presence: true
  validates_associated :user, :reviewable
end
