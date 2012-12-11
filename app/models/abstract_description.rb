require 'set'

class AbstractDescription < ActiveRecord::Base
  include PgSearch
  belongs_to :user
  belongs_to :describable, polymorphic: true
  attr_accessible :body, :published, :published_at, :title, :tag_list
  validates :title, :user, :presence => true
  validates_associated :user

  acts_as_taggable

  before_validation :normalize_categories

  protected
  def normalize_categories
    self.tag_list = Category.where(name: tag_list).map(&:self_and_ancestors).flatten.map(&:name).compact.uniq
  end
end
