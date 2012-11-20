# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "Users" do
	before do 
		@user = User.make!
	end


  it 'welcomes the user' do
    visit '/'
    page.should have_content('Welcome')
    click_link "Личный кабинет"
  end

	it "reset password form opened" do 
		get forget_password_path
		#fill_in 'email', :with => 'Some shit'
		response.status.should be(200)
	end

	it "try reset password" do 
		visit forget_password_path
		#fill_in 'email', :with => 'incorrect email'
		fill_in 'email', :with => 'test@email.ru'
		click_on 'Сбросить пароль'

		page.should have_content('Welcome') 
		#I18n.t('users.reset_password.errors.send_instruction'))
	end

  describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_path
      response.status.should be(200)
    end
  end
end
