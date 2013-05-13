# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Users' do
	before do
		@user = User.make!
	end

  def login email=@user.email, password=@user.password
    visit new_user_session_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_on 'Sign in'
  end

	it 'welcomes the user' do
    visit '/'
    page.should have_content("Добро пожаловать в Смородину")
  end

  it 'check url' do
    login
    visit "/profiles/#{@user.profile.id}"
    page.should have_content(@user.email)
  end

  it 'user login' do
    login
    current_path.should == root_path
  end

  it 'user incorrect login' do
  	login 'test' 'test'
    page.should have_content('Неправильный логин или пароль')
  end

  it 'user register' do
  	visit new_user_registration_path
  	fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password', with: 'tes123ter'
    click_on 'Sign up'
    current_path.should == '/users'
  end

  it 'not registers invalid attributes' do
  	visit new_user_registration_path
  	fill_in 'user_email', with: 'tester'
    fill_in 'user_password', with: 'tester'
    click_on 'Sign up'
    page.should have_content('Please review the problems below')
    page.should have_content('Passwordне совпадает с подтверждением')
    page.should have_content('Emailимеет неверное значение')
  end

  it 'should not be registered with excisting email' do
  	visit new_user_registration_path
  	fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'Sign up'
    page.should have_content('Emailуже существует')
  end

  it 'not change email without confirmation' do
    login
    find('.user-link .action-link').click
    click_on 'Личный кабинет'
    click_on 'Настройки'
    fill_in 'user_email', with: 'tester@test.er'
    fill_in 'user_current_password', with: @user.password
    find(:type, 'submit').click
		current_path.should == root_path
    page.should have_content('Ваша учетная запись изменена, вам выслано письмо подтверждения нового email')
    find('.user-link .action-link').click
    click_on 'Личный кабинет'
    click_on 'Настройки'
    find_field('user_email').value.should eq @user.email
    page.should have_content('Edit User')
  end

  it 'edit user' do
    # TODO move to profile spec
    login
    find('.user-link .action-link').click
    click_on 'Личный кабинет'
    click_on 'Edit'
    fill_in 'profile_name', with: 'tester'
    find(:type, 'submit').click
    page.should have_content('tester')
		#current_path.should == profile_path(@user)
  end

end

describe 'Users reset password' do
	before do
		@user = User.make!
	end

	it 'reset password form is opened' do
		visit root_path
		click_on 'Вход и регистрация'
		click_on 'Forgot your password?'
		page.should have_selector('input[type="email"]')
	end

	it 'fill email for reset password' do
		visit new_user_password_path
        find(:type, 'email').set(@user.email)
		find(:type, 'submit').click
		page.should have_content('В течение нескольких минут вы получите письмо с инструкциями по восстановлению вашего пароля')
		current_path.should == '/users/sign_in'
	end

	it 'add new password after reset password' do
    pending
		visit reset_password_url(token: @user.perishable_token)
		page.should have_selector('input#password')
		fill_in 'password', with: 'tester'
		find(:type, 'submit').click
		#click_on 'Сохранить'
		page.should have_content('Профиль')
		current_path.should == user_path(@user)
	end

  ### to use your account
  context 'Users social networks', js: true, type: :request do
    #self.use_transactional_fixtures = false

    before :each do
      page.driver.headers = {'Accept-Language' => 'q=0.8,en-US'}
    end


    it 'facebook login' do
      Capybara.app_host = 'http://localhost:3000'
      visit new_user_session_path
      click_on 'Sign in with Facebook'
      sleep 1
      current_url.should =~ /facebook/
      page.should have_content('Log in to use your Facebook account')
    end

    it 'twitter login' do
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      sleep 1
      current_url.should =~ /twitter/
      page.should have_content("to use your account") #have_content('Twitter / Authorize an application')
    end

    it 'facebook register' do
      Capybara.app_host = 'http://localhost:3000'
      visit new_user_session_path
      click_on 'Sign in with Facebook'
      sleep 1
      current_url.should =~ /facebook/
      page.should have_content('Facebook')
    end

    it 'twitter register' do
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      sleep 1
      current_url.should =~ /twitter/
    end
  end
end
