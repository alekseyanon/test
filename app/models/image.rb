class Image < ActiveRecord::Base
  attr_accessible :image
  mount_uploader  :image, ImageUploader
  belongs_to      :imageable, polymorphic: true
  belongs_to      :images

  acts_as_voteable

  before_save :attach_to_user

  def attach_to_user
    self.user = session[:user]
  end
end
