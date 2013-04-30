class Image < ActiveRecord::Base
  attr_accessible :image, :user_id
  mount_uploader  :image, ImageUploader
  belongs_to      :imageable, polymorphic: true
  belongs_to      :user

  acts_as_voteable

end
