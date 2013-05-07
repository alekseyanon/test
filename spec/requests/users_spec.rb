# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Users' do
	before do
		@user = User.make!
	end

  def login email=@user.email, password=@user.password
    visit root_path
    click_on "show_modal"
    fill_in 'user_email_log', with: email
    fill_in 'user_password_log', with: password
    click_on 'login'
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
    page.should have_content("Вход в систему выполнен.")
  end

  it 'user incorrect login' do
  	login 'test' 'test'
    page.should have_content('Неправильный логин или пароль')
  end

  it 'user register' do
  	visit root_path
  	fill_in 'user_email_reg', with: Faker::Internet.email
    fill_in 'user_password_reg', with: 'tes123ter'
    page.check 'user_rules'
    click_on 'register'
    current_path.should == '/users'
  end

  it "should register user with email notifications and name" do
    fake_email = Faker::Internet.email
    visit root_path
    fill_in 'user_email_reg', with: fake_email
    fill_in 'user_password_reg', with: 'tes123ter'
    fill_in 'user_name', with: 'Richard'
    page.check 'user_rules'
    page.check 'user_spam'
    click_on 'register'
    current_path.should == '/users'
    
    u = User.find_by_email(fake_email)
    p u.profile.settings
    u.profile.name.should == "Richard"
    u.profile.settings["news_mailer"].should == "1"
  end

  it 'not registers invalid attributes' do
  	visit root_path
  	fill_in 'user_email_reg', with: 'tester'
    fill_in 'user_password_reg', with: 'tester'
    page.check 'user_rules'
    click_on 'register'
    page.should have_content('Проверьте заполненные поля')
  end

  it "does not register if terms of service are not accepted" do
    visit root_path
    fill_in 'user_email_reg', with: 'tester'
    fill_in 'user_password_reg', with: 'tester'
    click_on 'register'
    page.should have_content("Вам необходимо принять соглашение")
  end

  it 'should not be registered with existing email' do
  	visit root_path
  	fill_in 'user_email_reg', with: @user.email
    fill_in 'user_password_reg', with: @user.password
    page.check 'user_rules'
    click_on 'register'
    find('#regLoginModal').should be_visible
  end

  it 'not change email without confirmation' do
    login
    find('.user-link .action-link').click
    click_on 'Личный кабинет'
    click_on 'Настройки'
    fill_in 'user_email', with: 'tester@test.er'
    fill_in 'user_current_password', with: @user.password
    click_on 'Update'
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
    find('.actions .btn').click
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
		click_on 'Забыли пароль?'
		page.should have_selector('input#user_email')
	end

	it 'fill email for reset password' do
		visit new_user_password_path
		fill_in 'user_email', with: @user.email
		find('.form-actions .btn').click
		#click_on 'Сбросить пароль'
		#print page.html
		page.should have_content('В течение нескольких минут вы получите письмо с инструкциями по восстановлению вашего пароля')
		current_path.should == '/users/sign_in'
	end

	it 'add new password after reset password' do
    pending
		visit reset_password_url(token: @user.perishable_token)
		page.should have_selector('input#password')
		fill_in 'password', with: 'tester'
		find('.form-actions .btn').click
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
