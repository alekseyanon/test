# encoding: UTF-8

module RspecHelper
  def login user=User.make!
    visit root_path
    click_on "show_registration_modal"
    fill_in 'user_login_email', with: user.email
    fill_in 'user_login_password', with: user.password
    click_on 'login'
  end
end
