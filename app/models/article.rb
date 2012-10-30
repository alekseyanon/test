class Article < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :published, :published_at, :title
  validates :title, :body, :presence => true
  #validates_associated :user #TODO validate associated user when User model is there
end
