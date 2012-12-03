class AbstractDescription < ActiveRecord::Base
  include PgSearch
  belongs_to :user
  belongs_to :describable, polymorphic: true
  attr_accessible :body, :published, :published_at, :title, :tag_list
  validates :title,  :presence => true #:body, :user,
  validates_associated :user

  acts_as_taggable
end
