class Comment < ActiveRecord::Base
  acts_as_nested_set
  attr_accessible :body
  belongs_to :commentable, polymorphic: true
  belongs_to :user
end
