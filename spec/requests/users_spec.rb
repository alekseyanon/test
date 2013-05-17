# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'Users' do
  before do
    @user = User.make!
  end

  def login email=@user.email, password=@user.password
    visit root_path
    page.find('#show_registration_modal').click
    fill_in 'user_login_email', with: email
    fill_in 'user_login_password', with: password
    page.find('#login').click
  end


  let(:fake_email){ Faker::Internet.email }

  let(:fake_password){ 'tes123ter' }

  let(:fake_name){ 'Richard' }

  it 'welcomes the user' do
    visit '/'
    page.should have_content('Добро пожаловать в Смородину')
  end

  it 'check url' do
    login
    visit "/profiles/#{@user.profile.id}"
    page.should have_content(@user.email)
  end

  it 'user login' do
    login
    page.should have_content('Вход в систему выполнен.')
  end

  it 'user incorrect login' do
    login 'test' 'test'
    page.should have_content('Неправильный логин или пароль')
  end

  it 'user register' do

    visit root_path
    fill_in 'user_registration_email', with: fake_email
    fill_in 'user_registration_password', with: fake_password
    page.check 'tos'
    click_on 'register'
    current_path.should == '/users'
  end

  it 'should register user with email notifications and name' do
    visit root_path
    fill_in 'user_registration_email', with: fake_email
    fill_in 'user_registration_password', with: fake_password
    fill_in 'user_name', with: fake_name
    page.check 'tos'
    page.check 'user_spam'
    click_on 'register'
    current_path.should == '/users'
    
    u = User.find_by_email(fake_email)
    u.profile.name.should == fake_name
    u.profile.settings['news_mailer'].should == '1'
  end

  it 'not registers invalid attributes' do

    visit root_path
    fill_in 'user_registration_email', with: 'tester'
    fill_in 'user_registration_password', with: 'tester'
    page.check 'tos'
    click_on 'register'
    page.should have_content('Проверьте заполненные поля')
  end

  it 'does not register if terms of service are not accepted' do
    visit root_path
    fill_in 'user_registration_email', with: 'tester'
    fill_in 'user_registration_password', with: 'tester'
    click_on 'register'
    page.should have_content('Вам необходимо принять соглашение')
  end

  it 'should not be registered with existing email' do
    visit root_path
    fill_in 'user_registration_email', with: @user.email
    fill_in 'user_registration_password', with: @user.password
    page.check 'tos'
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
    find('.password-form__button input').click
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
      Capybara.visit root_path
      page.find('#show_registration_modal').click
    end

    it 'facebook login' do
      find('.icon-fb').click
      current_url.should =~ /facebook/
    end

    it 'twitter login' do
      find('.icon-tw').click
      current_url.should =~ /twitter/
    end

  end
end
