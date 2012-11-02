# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  include AASM
  attr_accessible :email, :password, :password_confirmation, :name, :external_picture_url, :authentication_ids
  include UserFeatures::Roles
  has_many :authentications, :dependent => :destroy
  
  acts_as_authentic do |c|
    c.ignore_blank_passwords = false
  end
  ### TODO: add validations
  attr_accessor :old_password
  attr_accessor :need_to_check_old_password

  
  # MIN_PREFIX_LEN = 2
  # ON_FRONT_PAGE = 6

  
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

  
  # инициализует нового пользователя из данных регистрации
  def self.new_user(role, user_params)
    user_params = user_params.with_indifferent_access

    #User.find_fake_or_initialize(user_params)

    # TODO: Maybe, all that situated in block we can delete
    User.intlz(user_params).tap do |user|
      user.roles = [:traveler]
      user.email = user_params[:email]
    end
    
  end

  def self.intlz(attributes)
    user = new(attributes)
    user.password = attributes["password"]
    user.password_confirmation = attributes["password_confirmation"]
    user.email = attributes["email"]
    user.roles = [:traveler]
    user
  end
  # регистрирует пользователя в системе
  # options[:activate] если true, то активирует юзера, иначе высылает активационное письмо
  # options[:inviter_token]
  def register(options = {})
    registered = false

    transaction do
      if save
                # start_membership(:inviter_token => inviter_token) if (inviter_token = options[:inviter_token])
        # set_plan_on_signup(plan_name, plan_duration, plan_in_debt) if contractor?

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
    errors.add(:old_password, I18n.t("authlogic.error_messages.old_password_wrong"))
    false
  end

protected

  # while never used
  def merge_params(attrs)
    attrs["realm_ids"] = (attrs["realm_1"].nil? ? [] : attrs["realm_1"].to_a) + (attrs["realm_2"].nil? ? [] : attrs["realm_2"].to_a)
    attrs["branch_ids"] = (attrs["branches_1"].nil? ? [] : attrs["branches_1"]) + (attrs["branches_2"].nil? ? [] : attrs["branches_2"])
    attrs
    #raise attrs.inspect
  end

private


  # Копирует в имя часть емейла до '@'
  def set_default_name_from_email
    email.to_s.match(/(.*)@/)
    self.name = $1 if name.blank?
  end

  def activation
    reset_perishable_token!
    #set_default_subscription
  end

  def _after_activate
    Notifier.user_activated(self).deliver

    ### maybe we can add something that user created before activation

  end


end
