class TwitterAccount < ActiveRecord::Base
  # attr_accessible :title, :body
  CONSUMER_KEY = '13miB5TnS4NNXTXn94DA'
  CONSUMER_SECRET = 'zXmLg9CIivjOV6prxEGEuKGD29g7NpoK6aXM21ZQY'
  OPTIONS = {site: 'http://api.twitter.com', request_endpoint: 'http://api.twitter.com'}

  belongs_to :user

  def authorize_url(callback_url = '')
    if self.oauth_authorize_url.blank?
      # Step one, generate a request URL with a request token and secret
      signing_consumer = OAuth::Consumer.new(TwitterAccount::CONSUMER_KEY, TwitterAccount::CONSUMER_SECRET, TwitterAccount::OPTIONS)
      request_token = signing_consumer.get_request_token(:oauth_callback => callback_url)
      self.oauth_token = request_token.token
      self.oauth_token_secret = request_token.secret
      self.oauth_authorize_url = request_token.authorize_url
      self.save!
    end
    self.oauth_authorize_url
  end

  def validate_oauth_token(oauth_verifier, callback_url = '')
    begin
      signing_consumer = OAuth::Consumer.new(TwitterAccount::CONSUMER_KEY, TwitterAccount::CONSUMER_SECRET, TwitterAccount::OPTIONS)
      access_token = OAuth::RequestToken.new(signing_consumer, self.oauth_token, self.oauth_token_secret).
        get_access_token(:oauth_verifier => oauth_verifier)
      self.oauth_token = access_token.params[:oauth_token]
      self.oauth_token_secret = access_token.params[:oauth_token_secret]
      self.stream_url = "http://twitter.com/#{access_token.params[:screen_name]}"
      self.active = true
    rescue OAuth::Unauthorized
      self.errors.add(:oauth_token, "Invalid OAuth token, unable to connect to twitter")
      self.active = false
    end
    self.save!
  end

  def post(message)
    #Twitter.configure do |config|
    #  config.consumer_key = TwitterAccount::CONSUMER_KEY
    #  config.consumer_secret = TwitterAccount::CONSUMER_SECRET
    #  config.oauth_token = self.oauth_token
    #  config.oauth_token_secret = self.oauth_token_secret
    #end
    Twitter.configure do |config|
      config.consumer_key = '13miB5TnS4NNXTXn94DA'
      config.consumer_secret = 'zXmLg9CIivjOV6prxEGEuKGD29g7NpoK6aXM21ZQY'
      config.oauth_token = '471261730-OSGlKOnc6cAWZLABJyV1WM1aWGe9WIeV2PakyoMb'
      config.oauth_token_secret = '7TLeDs4ZqR6zhtyjY87hlafXRdTXVwpwuhckVeNOmI'
    end
    client = Twitter::Client.new
    begin
      client.update(message)
      return true
    rescue Exception => e
      self.errors.add(:oauth_token, "Unable to send to twitter: #{e.to_s}")
      return false
    end
  end

end
