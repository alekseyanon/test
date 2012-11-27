class AbstractDescription < ActiveRecord::Base
  include PgSearch
  belongs_to :user
  attr_accessible :body, :published, :published_at, :title
  validates :title, :body, :user, :presence => true
  validates_associated :user
end
