# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable     

  has_one :profile    

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid

  extend FriendlyId
  friendly_id :make_slug, use: :slugged

  include AASM
  include UserFeatures::Roles

  serialize :settings, ActiveRecord::Coders::Hstore

  mount_uploader :avatar, AvatarUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  attr_accessible :email, :password, :password_confirmation, :avatar, :name, 
                  :external_picture_url, :authentication_ids,
                  :crop_x, :crop_y, :crop_w, :crop_h

  after_update :crop_avatar 
  attr_accessor :old_password
  attr_accessor :need_to_check_old_password

  has_many :authentications, :dependent => :destroy
  has_many :abstract_descriptions
  
  #TODO hack
  before_validation :set_role

  ### TODO: add validations
  ### TODO: refactor
  ### TODO: add anonimous
  
  def settings
    read_attribute(:settings).nil? ? {} : read_attribute(:settings)
  end

  # AASM
  aasm :column => 'state' do
    state :pending_activation, :initial => true
    state :active, :enter => :activation
    state :blocked
    state :deleted#, :enter => :prepare_user_for_deletion

    event :activate, :after => :_after_activate do
      transitions :from => :pending_activation, :to => :active
    end

    event :deactivate do
      transitions :from => :active, :to => :pending_activation
    end

    event :block do
      transitions :from => :active, :to => :blocked
    end

    event :unblock do
      transitions :from => :blocked, :to => :active
    end

    event :soft_destroy do
      transitions :from => :active, :to => :deleted
    end 
  end

  # Scopes
  scope :in_state, lambda { |state|
    where(:state => state.to_s)
  }

  scope :in_states, lambda { |*states|
    where(:state => states.map { |s| s.to_s } )
  }
  
  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end
  
  
  def set_role
    self.roles = [:traveler]
  end

  def active?
    self.state == 'active'
  end

  def to_s
    deleted? ? "Аккаунт удален" : name
  end

  def name_domain_from_email
    email.split("@")
  end

  def should_generate_new_friendly_id?
    new_record?
  end

private

  # Копирует в имя часть емейла до '@'
  def set_default_name_from_email
    email.to_s.match(/(.*)@/)
    self.name = $1 if name.blank?
  end

  def activation
    #reset_perishable_token!

    logger.debug "-------------activation--------------------"
    #set_default_subscription
  end

  def _after_activate
    Notifier.user_activated(self).deliver
    ### maybe we can add something that user created before activation
  end

  def make_slug
    tmp_name = self.name ? self.name : self.email.split("@").first
    "#{tmp_name ? tmp_name : 'user'}"
  end
end
