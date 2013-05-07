class Image < ActiveRecord::Base
  attr_accessible :image
  mount_uploader  :image, ImageUploader

  has_many 				:comments, as: :commentable
  belongs_to      :imageable, polymorphic: true
  acts_as_voteable

end
