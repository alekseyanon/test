# encoding: UTF-8

module RspecHelper
  def login
    @user = User.make!
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'Sign in'
  end
end
