# -*- encoding : utf-8 -*-
social_cfg = YAML.load_file("#{Rails.root}/config/social_services.yml")
social_cfg = social_cfg[Rails.env]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, social_cfg['facebook']['id'], social_cfg['facebook']['secret']
  provider :twitter, social_cfg['twitter']['key'], social_cfg['twitter']['secret']
  provider :vkontakte, social_cfg['vkontakte']['id'], social_cfg['vkontakte']['secret']
  	# , 
    #  :scope => 'notify', 
    #  :client_options => {:ssl => {:ca_file => "#{Rails.root}/config/ca-bundle.crt"}}
end