class Profile < ActiveRecord::Base
  attr_accessible :avatar, :name, :surname, :settings

  belongs_to :user

  extend FriendlyId
  friendly_id :make_slug, use: :slugged

  mount_uploader :avatar, AvatarUploader
  serialize :settings, ActiveRecord::Coders::Hstore

  validates :surname, format:
      {with: /\A[\u{0430}-\u{044F}\u{0410}-\u{042F}\\sA-Za-z]+\z/}, on: :update

  def settings
    read_attribute(:settings).nil? ? {} : read_attribute(:settings)
  end

  private

  def make_slug
    tmp_name = self.name ? self.name : self.user.email.split('@').first
    "#{tmp_name ? tmp_name : 'user'}"
  end

end
