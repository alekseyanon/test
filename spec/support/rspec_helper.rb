# encoding: UTF-8

module RspecHelper
  def login user=User.make!
    visit root_path
    click_on "show_modal"
    fill_in 'user_email_log', with: user.email
    fill_in 'user_password_log', with: user.password
    click_on 'login'
  end
end
