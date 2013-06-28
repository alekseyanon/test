source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'strong_parameters'

gem 'pg'
gem 'rgeo-activerecord'
gem 'activerecord-postgis-adapter'
gem 'activerecord-postgres-hstore'
gem 'activerecord-postgres-array'

gem 'acts-as-taggable-on'
gem 'awesome_nested_set'
gem 'ancestry'

gem 'inherited_resources'
gem 'russian'
gem 'chronic'
gem 'ice_cube'

gem 'pg_search'

gem 'sxgeo'

gem 'kaminari'

gem 'rabl'

gem 'whenever', :require => false

################## views #########################
gem 'simple_form'
gem 'haml-rails'
gem 'haml'
gem 'select2-rails'

##################################################
########### gems for users models ################
gem 'devise'
gem 'cancan'

### we need authentification through VK, FB, Twitter
gem 'omniauth'
gem 'omniauth-oauth2', '1.0.3'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-vkontakte'
# gem 'omniauth-mailru'
# gem 'omniauth-google-oauth2'

####  Gem for posting to social networks
#### twitter
gem 'oauth'
gem 'twitter', git: 'git://github.com/sferik/twitter.git'

#### facebook
gem 'koala'

gem 'aasm', '3.0.4'
gem 'state_machine'
gem 'magic_numbers', git: 'git://github.com/gzigzigzeo/magic_numbers.git' # Sotakone improved

# for user avatar
gem 'carrierwave'
gem 'mime-types', require: 'mime/types'
gem 'rmagick'
gem 'mini_magick'

##################################################

gem 'rinku'               # auto_link
gem 'friendly_id'         # slug

### To update bundle update --source thumbs_up
gem 'thumbs_up', git: 'git://github.com/lvl0nax/thumbs_up'           # voting system

gem 'redactor-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'bootstrap-sass', '~> 2.3.0.1'
  gem 'coffee-rails'
  gem 'compass-rails'
  gem 'modernizr-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'backbone-on-rails'
  gem 'haml_coffee_assets'
  gem 'execjs'
  gem 'quiet_assets', :group => :development
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'rails_jquery_ui_datepicker'
gem 'spinjs-rails'
gem 'momentjs-rails'
gem 'jquery-fileupload-rails'

gem 'capistrano'
gem 'rvm-capistrano'

gem 'ptools'

gem 'machinist' #TODO should be in test group, but required during deploy for objects:populate
gem 'faker'

group :test, :development do
  gem 'rspec',   '~> 2.12'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'diff-lcs'
  gem 'capybara', '~> 2.0'
  gem 'capybara-screenshot'
  gem 'launchy'
  gem 'pry'
  gem 'poltergeist'
  gem 'database_cleaner'
end
