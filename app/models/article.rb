class Article < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :published, :published_at, :title
  validates :title, :body, :user, :presence => true
  validates_associated :user

  include PgSearch
  multisearchable :against => [:title, :body]
end
