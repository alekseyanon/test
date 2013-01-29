# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Users" do
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
    page.should have_content('Welcome')
  end

  it 'check url' do
    login
    visit "/profiles/#{@user.profile.id}"
    page.should have_content('Профиль')
  end

  it "user login" do 
    login
    current_path.should == root_path
  end

  it "user incorrect login" do 
  	login 'test' 'test'
    page.should have_content('Ошибка, проверьте email и пароль и повторите попытку снова.')
  end

  it "user register" do 
  	visit new_user_registration_path
  	fill_in 'user_email', with: Faker::Internet.email
    fill_in 'user_password', with: "tes123ter"
    click_on 'Sign up'
    current_path.should == pendtoact_path
  end

  it "user incorrect register" do 
  	visit new_user_registration_path
  	fill_in 'user_email', with: "tester"
    fill_in 'user_password', with: "tester"
    click_on 'Sign up'
    page.should have_content('Email имеет неверное значениеPassword не совпадает с подтверждениемPassword недостаточной длины')
  end

  it "user register with data of already exists user" do 
  	visit profile_path(type: 'traveler')
  	fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'Зарегистрироваться'
    page.should have_content('Email уже существует')
  end

  it "user settings" do 
    login
    click_on 'Профиль'
    click_on 'Настройки'
    fill_in 'user_email', with: "tester@test.er"
    find(:type, "submit").click
		current_path.should == user_path(@user)
    click_on "Настройки"
    find_field('user_email').value.should eq 'tester@test.er'
    page.should have_content('Редактирование профиля')
  end

  it "edit user" do 
    # TODO move to profile spec
    login
    click_on 'Профиль'
    click_on 'Edit'
    fill_in 'profile_name', with: "tester"
    find(:type, "submit").click
    page.should have_content('tester') 
		#current_path.should == profile_path(@user)
  end

end

describe "Users reset password" do
	before do 
		@user = User.make!
	end  

	it "reset password form is opened" do 
		visit root_path
		click_on 'Войти'
		click_on 'Forgot your password?'
		page.should have_selector('input#user_email')
	end

	it "fill email for reset password" do 
		visit forget_password_path
		fill_in 'email', with: @user.email
		find(:type, "submit").click
		
		#click_on 'Сбросить пароль'
		#print page.html
		page.should have_content(@user.email) 
		current_path.should == root_path
	end

	it "add new password after reset password" do 
    pending
		visit reset_password_url(token: @user.perishable_token)
		page.should have_selector('input#password')

		fill_in 'password', with: 'tester'
		find(:type, "submit").click
		#click_on 'Сохранить'
		page.should have_content('Профиль') 
		current_path.should == user_path(@user)
	end


  ### to use your account
  context "Users social networks", js: true, type: :request do
    #self.use_transactional_fixtures = false

    before :each do
      page.driver.headers = {'Accept-Language' => 'q=0.8,en-US'}
    end


    it "facebook login" do
      Capybara.app_host = 'http://localhost:3000'
      visit profile_path(type: 'traveler')
      page.find('a.facebook').click
      wait_until(5) do
        page.find('title').should have_content('Log In | Facebook')
      end
    end

    it "twitter login" do
      visit profile_path(type: 'traveler')
      page.find('.social-icon.twitter').click
      wait_until(5) do
        page.find('title').should have_content('Twitter / Authorize an application')
      end
    end

    it "facebook register" do
      Capybara.app_host = 'http://localhost:3000'
      visit profile_path(type: 'traveler')
      page.find('button.facebook').click
      wait_until(5) do
        page.find('title').should have_content('Log In | Facebook')
      end
    end

    it "twitter register" do
      visit profile_path(type: 'traveler')
      page.find('button.twitter').click
      wait_until(5) do
        page.find('title').should have_content('Twitter / Authorize an application')
      end
    end
  end
end
