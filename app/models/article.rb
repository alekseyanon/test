class Article < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :published, :published_at, :title
end
