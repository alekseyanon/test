class Profile < ActiveRecord::Base
  attr_accessible :avatar, :name, :settings, :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  belongs_to :user

  extend FriendlyId
  friendly_id :make_slug, use: :slugged

  mount_uploader :avatar, AvatarUploader
  serialize :settings, ActiveRecord::Coders::Hstore

  after_update :crop_avatar 

  def settings
    read_attribute(:settings).nil? ? {} : read_attribute(:settings)
  end

  private

  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end

  def make_slug
    tmp_name = self.name ? self.name : self.user.email.split("@").first    
    "#{tmp_name ? tmp_name : 'user'}"
  end

end
