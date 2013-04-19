class Authentication < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  validates :uid, uniqueness: {scope: :provider}, presence: true
  attr_accessible :provider, :uid, :name, :email, :oauth_token, :oauth_token_secret

  def twitter_post(message)
    social_cfg = YAML.load_file("#{Rails.root}/config/social_services.yml")
    social_cfg = social_cfg[Rails.env]

    Twitter.configure do |config|
      config.consumer_key = social_cfg['twitter']['key']
      config.consumer_secret = social_cfg['twitter']['secret']
      config.oauth_token = self.oauth_token
      config.oauth_token_secret = self.oauth_token_secret
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

  def facebook_post(message)
    @graph = Koala::Facebook::API.new(self.oauth_token)
    @graph.put_connections("me", "feed", message: message)
    return
  end

end
