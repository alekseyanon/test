class UserSession < Authlogic::Session::Base
  # attr_accessible :title, :body
  validate :check_for_role
  attr_accessor :role
  disable_magic_states true

  private

  def check_for_role
    return true if role.blank?
    return true if attempted_record.nil?
    errors.add(:role, "Error with role, which should be localized") if errors.empty? && !attempted_record.role?(role)
    false
  end
end
