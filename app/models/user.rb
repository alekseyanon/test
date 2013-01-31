# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # :token_authenticatable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :provider, :uid, :authentication_ids

  include AASM
  include UserFeatures::Roles

  attr_accessor :old_password
  attr_accessor :need_to_check_old_password

  has_many :authentications, dependent: :destroy
  has_many :abstract_descriptions
  has_one :profile

  #TODO hack
  before_validation :set_role
  after_create :create_profile

  def create_profile
    self.create_profile!
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
    end
  #   user.create_profile
  #   user.profile.name = auth.info.nickname
  #   user.profile.save
  end

  def self.new_with_session(params, session)
    # binding.pry
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"].except('roles'), without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  ### TODO: add validations
  ### TODO: refactor
  ### TODO: add anonimous

  # AASM
  aasm column: 'state' do
    state :pending_activation, initial: true
    state :active, enter: :activation
    state :blocked
    state :deleted#, :enter => :prepare_user_for_deletion

    event :activate, after: :_after_activate do
      transitions from: :pending_activation, to: :active
    end

    event :deactivate do
      transitions from: :active, to: :pending_activation
    end

    event :block do
      transitions from: :active, to: :blocked
    end

    event :unblock do
      transitions from: :blocked, to: :active
    end

    event :soft_destroy do
      transitions from: :active, to: :deleted
    end
  end

  # Scopes
  scope :in_state, lambda { |state|
    where(:state => state.to_s)
  }

  scope :in_states, lambda { |*states|
    where(:state => states.map { |s| s.to_s } )
  }

  def set_role
    self.roles = [:traveler]
  end

  def active?
    self.state == 'active'
  end

  # def to_s
  #   deleted? ? "Аккаунт удален" : name
  # end

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
    # Notifier.user_activated(self).deliver
    ### maybe we can add something that user created before activation
  end

end
