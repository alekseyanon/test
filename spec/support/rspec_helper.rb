# encoding: UTF-8

module RspecHelper
  def login user=User.make!
    #visit root_path
    #click_on "show_registration_modal"
    Capybara.visit('/')
    page.find('#show_registration_modal').click
    fill_in 'user_login_email', with: user.email
    fill_in 'user_login_password', with: user.password
    page.find('#login').click
    #click_on 'login'
  end
end
