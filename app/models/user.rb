# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # TODO avatar crop!
  # :token_authenticatable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :provider, :uid, :authentication_ids

  has_many :ratings

  has_many :comments
  has_many :reviews
  has_many :complaints

  acts_as_voter
  ### TODO: may be useful for calculation user rating
  # The following line is optional, and tracks karma (up votes) for questions this user has submitted.
  # Each question has a submitter_id column that tracks the user who submitted it.
  # The option :weight value will be multiplied to any karma from that voteable model (defaults to 1).
  # You can track any voteable model.
  # has_karma(:questions, :as => :submitter, :weight => 0.5)

  include AASM
  include UserFeatures::Roles

  has_many :authentications, dependent: :destroy
  has_many :geo_objects
  has_one :profile

  #TODO remove hack
  before_validation :set_role
  after_create :create_profile

  validate :uniqueness_user

  def create_profile
    self.create_profile!
  end

  def identifier
    self.email.blank? ? "Профиль пользователя #{self.id}" : self.email
  end

  #def self.from_omniauth(auth)
  #  where(auth.slice(:provider, :uid)).first_or_initialize do |user|
  #    user.provider = auth.provider
  #    user.uid = auth.uid
  #    user.skip_confirmation!
  #    user.save
  #  end
  #end
  #
  #def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  #  user = User.where(:provider => auth.provider, :uid => auth.uid).first
  #  unless user
  #    user = User.find_by_email(auth.info.email)
  #    user.update_attributes(provider: auth.provider, uid:auth.uid) if user
  #  end
  #  unless user
  #    user = User.new(
  #                       provider:auth.provider,
  #                       uid:auth.uid,
  #                       email:auth.info.email,
  #                       password:Devise.friendly_token[0,20]
  #    )
  #    user.skip_confirmation!
  #    user.save
  #  end
  #  user
  #end
  #
  #def self.new_with_session(params, session)
  #
  #  if userattr = session["devise.user_attributes"]
  #    new(userattr.except('roles'), without_protection: true) do |user|
  #      user.attributes = params
  #      user.valid?
  #    end
  #  else
  #    super
  #  end
  #end

  def password_required?
    super && provider.blank?
  end

  def email_required?
    super && self.authentications.blank?
  end

  ### TODO: add validations
  ### TODO: refactor
  ### TODO: add anonimous

  # AASM
  # TODO Move to state_machine
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

  #TODO remove hack
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

  def uniqueness_user
    if self.email.blank?
      if self.authentications.blank?
        errors.add(:email, 'can not be blank without authentications')
      end
    else
      errors.add(:email, ' is not uniq') if User.pluck(:email).uniq.include? self.email
    end
  end

  # Копирует в имя часть емейла до '@'
  def set_default_name_from_email
    email.to_s.match(/(.*)@/)
    self.name = $1 if name.blank?
  end

end
