# encoding: UTF-8

module RspecHelper
  def login user=User.make!
    Capybara.visit('/')
    page.should have_selector('#show_registration_modal')
    find('#show_registration_modal').click
    fill_in 'user_login_email', with: user.email
    fill_in 'user_login_password', with: user.password
    page.should have_selector('#login')
    find('#login').click
    try_click '#login', 2
  end

  def try_click(selector, count)
    count.times { find(selector).click if page.has_selector?(selector) }
  end
end
