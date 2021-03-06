# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'

# Uncomment to disable failures on js errors
# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app, {js_errors: false})
# end

Capybara.javascript_driver = :poltergeist

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include RspecHelper, type: :request
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include Capybara::DSL

  Capybara.server_port = 54321 + ENV.fetch('TDDIUM_TID', 0).to_i
  Capybara.add_selector(:type) do
    xpath { |type| XPath.descendant[XPath.attr(:type) == type.to_s] }
  end
end

### TODO: change with devise helpers
def current_user(stubs = {})
  @current_user ||= stub_model(User, stubs)
end

def user_session(stubs = {}, user_stubs = {})
  default_stub = {user: current_user(user_stubs), record: true, anonymous?: false}
  @user_session ||= stub_model(UserSession, default_stub.merge(stubs))
end

def login(session_stubs = {}, user_stubs = {})
  UserSession.stub!(:find).and_return(user_session(session_stubs, user_stubs))
end

def logout
  @user_session = nil
end

def js_click(selector)
  page.execute_script("$('#{selector}').click();")
end

def get_credentials
  {'credentials' => {
      'token' => '471261730-OSGlKOnc6cAWZLABJyV1WM1aWGe9WIeV2PakyoMb'
  }}
end

def check_create model, json
  expect {
    post :create, {format: :json}.merge!(json)
  }.to change(model, :count).by(1)
end
