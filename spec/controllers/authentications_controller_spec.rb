require 'spec_helper'

describe AuthenticationsController do
  before :each do
    @uid = (Time.now.to_i + rand(1000)).to_s
    request.env['omniauth.auth'] = get_credentials.merge(
                                                          'provider' => 'twitter',
                                                          'uid' => @uid
                                                         )

  end

  it 'POST create authentications without users' do
    -> do
      post :create
    end.should change(User, :count).by(1)
    User.last.authentications.last.uid.should == @uid
    response.should redirect_to(root_path)
  end

  it 'POST create authentications with current_user' do
    user = User.make!
    controller.stub current_user: user
    -> do
      post :create
    end.should_not change(User, :count)
    user.authentications.last.uid.should == @uid
    response.should redirect_to(authentications_path)
  end

  it 'POST login as current_user with authentication' do
    auth = Authentication.make!(uid: @uid,
                                provider: 'twitter',
                                oauth_token: '471261730-OSGlKOnc6cAWZLABJyV1WM1aWGe9WIeV2PakyoMb')
    user = auth.user
    controller.stub current_user: user
    -> do
      post :create
    end.should_not change(Authentication, :count)
    user.authentications.last.uid.should == @uid
    response.should redirect_to(authentications_path)
  end
end
