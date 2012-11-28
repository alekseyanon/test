# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Users" do
	before do 
		@user = User.make!
	end

	describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_path
      response.status.should be(200)
    end
  end

	it 'welcomes the user' do
    visit '/'
    page.should have_content('Welcome')
  end

  it "user login" do 
  	visit profile_path(:type => 'traveler')
  	fill_in 'user_session[email]', with: @user.email
    fill_in 'user_session[password]', with: @user.password
    click_on 'Войти'
    current_path.should == root_path
  end

  it "user incorrect login" do 
  	visit profile_path(:type => 'traveler')
  	fill_in 'user_session[email]', with: "tests"
    fill_in 'user_session[password]', with: "tests"
    click_on 'Войти'
    page.should have_content('Ошибка, проверьте email и пароль и повторите попытку снова.')
  end

  it "user register" do 
  	visit profile_path(:type => 'traveler')
  	fill_in 'user[email]', with: "tester@test.ru"
    fill_in 'user[password]', with: "tester"
    click_on 'Зарегистрироваться'
    current_path.should == pendtoact_path
  end

  it "user incorrect register" do 
  	visit profile_path(:type => 'traveler')
  	fill_in 'user[email]', with: "tester"
    fill_in 'user[password]', with: "tester"
    click_on 'Зарегистрироваться'
    page.should have_content('содержит некорректные символы')
  end

  it "user register with data of already exists user" do 
  	visit profile_path(:type => 'traveler')
  	fill_in 'user[email]', with: @user.email
    fill_in 'user[password]', with: @user.password
    click_on 'Зарегистрироваться'
    page.should have_content('Email уже существует')
  end

  it "user settings" do 
  	visit profile_path(:type => 'traveler')
  	fill_in 'user_session[email]', with: @user.email
    fill_in 'user_session[password]', with: @user.password
    click_on 'Войти'
    click_on 'Настройки'
    fill_in 'user_email', with: "tester@test.er"
    find(:type, "submit").click
		current_path.should == user_path(@user)
    click_on "Настройки"
    page.should have_content('tester@test.er')
  end

  it "edit user" do 
  	visit profile_path(:type => 'traveler')
  	fill_in 'user_session[email]', with: @user.email
    fill_in 'user_session[password]', with: @user.password
    click_on 'Войти'
    click_on 'Редактировать профиль'
    fill_in 'user_name', with: "tester"
    find(:type, "submit").click
    page.should have_content('tester') 
		current_path.should == user_path(@user)
  end

end

describe "Users reset password" do
	before do 
		@user = User.make!
	end  

	it "reset password form is opened" do 
		visit root_path
		click_on 'Личный кабинет'
		click_on 'Забыли пароль'
		page.should have_selector('input#email')
	end

	it "fill email for reset password" do 
		visit forget_password_path
		fill_in 'email', :with => @user.email
		find(:type, "submit").click
		
		#click_on 'Сбросить пароль'
		#print page.html
		page.should have_content(@user.email) 
		current_path.should == root_path
	end

	it "add new password after reset password" do 
		visit reset_password_url(:token => @user.perishable_token)
		page.should have_selector('input#password')

		fill_in 'password', :with => 'tester'
		find(:type, "submit").click
		#click_on 'Сохранить'
		page.should have_content('Профиль') 
		current_path.should == user_path(@user)
	end

end