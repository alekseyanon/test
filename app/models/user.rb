# -*- coding: utf-8 -*-
class User < ActiveRecord::Base

  has_many :ratings
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
  
  acts_as_authentic do |c|
    c.ignore_blank_passwords = false
  end
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
  
  # инициализует нового пользователя из данных регистрации
  def self.new_user(role, user_params)
    user_params = user_params.with_indifferent_access

    User.intlz(user_params).tap do |user|
      user.roles = [:traveler]
    end
  end

  def self.intlz(attributes)
    user = new(attributes)
    user.password = attributes["password"]
    user.password_confirmation = attributes["password"]
    user
  end

  # регистрирует пользователя в системе
  # options[:activate] если true, то активирует юзера, иначе высылает активационное письмо
  # options[:inviter_token]
  def register(options = {})
    registered = false

    transaction do
      if save
        if options.delete(:activate)
          activate
        else
          Notifier.signup_confirmation(self).deliver
        end
        registered = true
      end
    end

    registered
  end

  # def subscribed_to_notifications?
  #   subscription.notifications
  # end

  # def subscribed_to?(subscription_name, subscription_period = :daily)
  #   subscription.subscribed_to?(subscription_name, subscription_period)
  # end

  # Authlogic method to check if user is allowed to log in
  def active?
    self.state == 'active'
  end

  def to_s
    deleted? ? "Аккаунт удален" : name
  end

  def name_domain_from_email
    email.split("@")
  end

  # Проверка на то, что старый пароль введен правильно
  validate :check_old_password
  def check_old_password
    return true unless @need_to_check_old_password
    return true if self.valid_password?(old_password)
    errors.add(:old_password, "Старый пароль введен не верно.")
    false
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
