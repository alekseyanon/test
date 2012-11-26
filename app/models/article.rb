class Article < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :published, :published_at, :title
  validates :title, :body, :user, :presence => true
  validates_associated :user

  #TODO update or remove fulltext search from Article, it's here just for demo purpose, not covered in specs
  include PgSearch
  pg_search_scope :search_full_text, against:{title:'A',body:'B'}

  def self.search(query)
    query ? Article.search_full_text(query) : Article.all
  end
end
