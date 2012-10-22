class UserSession < Authlogic::Session::Base
  # attr_accessible :title, :body
  validate :check_for_role
  attr_accessor :role
end
