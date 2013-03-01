module ControllerHelpers
  # def sign_in user =  User.make! #double('user')
  #   if user.nil?
  #     request.env['warden'].stub(:authenticate!).
  #       and_throw(:warden, {:scope => :user})
  #     controller.stub :current_user => nil
  #   else
  #     request.env['warden'].stub :authenticate! => user
  #     controller.stub :current_user => user
  #   end
  # end
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryGirl.create(:admin) # Using factory girl as an example
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings['user']
      user = User.make! #FactoryGirl.create(:user)
      user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the confirmable module
      sign_in user
    end
  end
end
