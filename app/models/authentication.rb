class Authentication < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  validates :uid, :uniqueness => {:scope => :provider}

  # Создает пользователя по параметрам, возвращенным из социалки.
  def new_user(*args)
    options = args.extract_options!
    password = SecureRandom.base64(12)

    attrs = options.merge(
      :name => self.name,
      :password => password,
      :password_confirmation => password,
      :external_picture_url => self.picture,
      # :state => 'pending_activation',
      :authentication_ids => [self.id])

    self.user = User.new(attrs)
    self.user.tap do |user|
      pass = SecureRandom.base64
      user.roles = [self.role]
      user.email = self.email
      user.password = pass
      user.password_confirmation = pass
    end
  end

  class << self
    # Получает на вход хеш omniauth.
    # Возвращает объект Authentication с заполненными параметрами.
    def find_or_create_from_provider(auth, params)
      # logger.debug "===================================================="
      # logger.debug "auth :" + auth.to_s
      # logger.debug "params :" + params.to_s


      params.stringify_keys!

      provider  = auth['provider']
      uid       = self.get_uid(auth)
      user_info = auth['info']

      user_name = user_info['name'] || uid
      www       = user_info['urls'].values.first if user_info['urls'].present?
      www       = user_info['urls']['Twitter'] if user_info['urls'].present? && provider.to_s == "twitter"
      picture   = user_info['image']

      role_name = params['type']

      # Через #tap, а не через блок: если регистрация была прервана - нужно перезанести данные.
      self.find_or_create_by_provider_and_uid(provider, uid).tap do |a|
        a.name           = user_name
        a.role           = role_name
        a.url            = www
        a.email          = user_info['email']
        a.picture        = picture
        a.save!
      end
    end

    # i think that it method can be deleted
    def get_uid(auth)
      uid = auth['provider'] == 'google' ? auth['info']['email'].gsub(/@gmail.com/,'') : auth['uid']
    end
  end
end
