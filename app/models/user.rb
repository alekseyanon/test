# -*- coding: utf-8 -*-
class User < ActiveRecord::Base

  USER_WINDOW_PAGINATION = 20
  paginates_per 10
  # TODO avatar crop!
  # :token_authenticatable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :provider, :uid, :authentication_ids, :expert, :discoverer,
                  :photographer, :blogger, :commentator

  has_many :ratings

  has_many :comments
  has_many :runtips
  has_many :events
  has_many :reviews
  has_many :complaints
  has_many :images

  has_many :video_links
  has_many :you_tubes, through: :video_links, uniq: true, source: :video, source_type: 'YouTube'
  has_many :vimeos,    through: :video_links, uniq: true, source: :video, source_type: 'Vimeo'

  scope :sorted_list_with_page, ->(cond, page = 0) { order(cond, 'created_at DESC').
                                                     offset(page*USER_WINDOW_PAGINATION) }

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

  delegate :name, to: :profile
  delegate :avatar_url, to: :profile

  #TODO remove hack
  before_validation :set_role
  after_create :create_profile

  #TODO add roles and role check
  def admin?
    false
  end

  validate :uniqueness_user, on: :create
  def uniqueness_user
    if self.email.blank?
      if self.authentications.blank?
        self.errors.add(:email, 'Either email or social network authentication is required')
      end
    else
      self.errors.add(:email, ' is already in use') if User.pluck(:email).uniq.include? self.email
    end
  end

  def username
    self.name || (self.email.blank? ? nil : self.email) || "Пользователь #{self.id}"
  end

  def create_profile
    self.create_profile!
  end

  def password_required?
    super && provider.blank?
  end

  def email_required?
    super && self.authentications.blank?
  end

  ### TODO: Add state_machine

  #TODO remove hack
  def set_role
    self.roles = [:traveler]
  end

  def should_generate_new_friendly_id?
    new_record?
  end

  def create_authentication(oauth)
    self.authentications.create!(User.prepare_args_for_auth(oauth))
  end

  def get_vote voteable, tag = nil
    args = {voteable_id: voteable.id, voteable_type: voteable.class}
    args.merge!(voteable_tag: tag) if tag
    v = self.votes.where(args).first
    v.nil? ? 0 : (v.vote ? 1 : -1)
  end

  def self.find_or_create(auth, oauth)
    args = prepare_args_for_auth(oauth)
    if auth # Пользователь не вошел в систему, но authentication найдена
            # залогинить пользователя.
      auth.user
    else # Пользователь не вошел на сайт и authentication не найдена
         # найти или создать пользователя, создать authentication и залогинить его
         #поиск пользователя по email
      user = args[:email] && self.find_by_email(args[:email])
      if user
        #Создаем authentication и залогиниваем пользователя
        user.authentications.create!(args)
      else
        # Создаем пользователя и authentication и залогиниваем его.
        user = self.new(password: Devise.friendly_token[0,20])
        user.authentications.build(args)
        user.skip_confirmation!
        user.save!
        user.confirm!
      end
      if user.name.blank?
        user.profile.name = args[:name]
        user.profile.save!
      end
      user
    end
  end

  def self.prepare_args_for_auth(oauth)
    args = {provider: provider = oauth['provider'], uid: oauth['uid']}
    email = (info = oauth['info']) && info['email']
    token = (cred = oauth['credentials']) && cred['token']
    name = info['name'] if info
    token_secret = cred && cred['secret']
    args.merge! case provider
                  when 'facebook';  {email: email,                     oauth_token: token}
                  when 'twitter';   {oauth_token_secret: token_secret, oauth_token: token}
                  when 'vkontakte'; {name: name,                       oauth_token: token}
                  else
                    raise NotImplementedError, "#{provider} oauth provider not supported"
                end
  end

  CLASS_TO_ATTR_AND_K = {
                      Comment   => [:commentator, 1.08],
                      #Post      => [:blogger, 1.42],
                      Review    => review_val = [:expert, 1.3],
                      Runtip    => review_val,
                      Image     => [:photographer, 1.2],
                      GeoObject => [:discoverer, 140]
                    }.each_value(&:freeze).freeze

  def update_rating(voteable, delta)
    attr, k = CLASS_TO_ATTR_AND_K[voteable.class]
    if attr
      self[attr] += delta*k
      self.save!
    end
  end
end
