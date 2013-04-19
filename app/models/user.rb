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

  include UserFeatures::Roles

  has_many :authentications, dependent: :destroy
  has_many :geo_objects
  has_one :profile

  #TODO remove hack
  before_validation :set_role
  after_create :create_profile

  validate :uniqueness_user, on: :create
  def uniqueness_user
    if self.email.blank?
      if self.authentications.blank?
        self.errors.add(:email, 'can not be blank without authentications')
      end
    else
      self.errors.add(:email, ' is not uniq') if User.pluck(:email).uniq.include? self.email
    end
  end

  def create_profile
    self.create_profile!
  end

  def identifier
    self.email.blank? ? "Профиль пользователя #{self.id}" : self.email
  end

  def password_required?
    super && provider.blank?
  end

  def email_required?
    super && self.authentications.blank?
  end

  ### TODO: add validations
  ### TODO: refactor
  ### TODO: Add state_machine

  #TODO remove hack
  def set_role
    self.roles = [:traveler]
  end

  def should_generate_new_friendly_id?
    new_record?
  end
end
