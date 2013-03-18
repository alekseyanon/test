source 'https://rubygems.org'

gem 'rails', '3.2.11'

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

gem 'kaminari'

################## views #########################
gem 'simple_form'
gem 'haml-rails'
gem 'haml'
gem 'chosen-rails'

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

gem 'aasm', '3.0.4'
gem 'magic_numbers', git: 'git://github.com/gzigzigzeo/magic_numbers.git' # Sotakone improved

# for user avatar
gem 'carrierwave'
gem 'mime-types', require: 'mime/types'
gem 'rmagick'
##################################################

gem 'rinku'               # auto_link
gem 'friendly_id'         # slug
gem 'thumbs_up'           # voting system

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'bootstrap-sass', '~> 2.3.0.1'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'modernizr-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'backbone-on-rails'
  gem 'haml_coffee_assets'
  gem 'execjs'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'rails_jquery_ui_datepicker'
gem 'spinjs-rails'

gem 'capistrano'
gem 'rvm-capistrano'

gem 'ptools'

gem 'machinist' #TODO should be in test group, but required during deploy for landmarks:populate
gem 'faker'

group :test, :development do
  gem 'rspec',   '~> 2.12'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'diff-lcs'
  gem 'capybara'
  gem 'launchy'
  gem 'pry'
  gem 'poltergeist'
  gem 'database_cleaner'
end
