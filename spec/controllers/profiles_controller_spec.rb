# encoding: UTF-8
require 'spec_helper'

describe ProfilesController do

  ### TODO: make with devse helper methods
  before :each do
    sign_in
  end

  def valid_attributes
    { 'name' => 'Константин', 'surname' => 'Константинопольский'}
  end

  def valid_session
    {}
  end

  describe 'GET index' do
    it 'assigns all profiles as @profiles' do
      # TODO надо переписать
      pending
      profile = Profile.create! valid_attributes
      get :index, {}, valid_session
      assigns(:profiles).should eq([profile])
    end
  end

  describe 'GET show' do
    it 'assigns the requested profile as @profile' do
      profile = Profile.create! valid_attributes
      get :show, {:id => profile.to_param}, valid_session
      assigns(:profile).should eq(profile)
    end
  end

  describe 'GET new' do
    it 'assigns a new profile as @profile' do
      get :new, {}, valid_session
      assigns(:profile).should be_a_new(Profile)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested profile as @profile' do
      profile = Profile.create! valid_attributes
      get :edit, {:id => profile.to_param}, valid_session
      assigns(:profile).should eq(profile)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Profile' do
        expect {
          post :create, {:profile => valid_attributes}, valid_session
        }.to change(Profile, :count).by(1)
      end

      it 'assigns a newly created profile as @profile' do
        post :create, {:profile => valid_attributes}, valid_session
        assigns(:profile).should be_a(Profile)
        assigns(:profile).should be_persisted
      end

      it 'redirects to the created profile' do
        post :create, {:profile => valid_attributes}, valid_session
        response.should redirect_to(Profile.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved profile as @profile' do
        # Trigger the behavior that occurs when invalid params are submitted
        Profile.any_instance.stub(:save).and_return(false)
        post :create, {:profile => { 'name' => 'invalid value'}}, valid_session
        assigns(:profile).should be_a_new(Profile)
      end

      it "re-renders the 'new' template" do
        pending
        # Trigger the behavior that occurs when invalid params are submitted
        Profile.any_instance.stub(:save).and_return(false)
        post :create, {:profile => { 'name' => 'invalid value'}}, valid_session
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested profile' do
        profile = Profile.create! valid_attributes
        # Assuming there are no other profiles in the database, this
        # specifies that the Profile created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Profile.any_instance.should_receive(:update_attributes).with({ 'name' => 'MyString'})
        put :update, {:id => profile.to_param, :profile => { 'name' => 'MyString'}}, valid_session
      end

      it 'assigns the requested profile as @profile' do
        profile = Profile.create! valid_attributes
        put :update, {:id => profile.to_param, :profile => valid_attributes}, valid_session
        assigns(:profile).should eq(profile)
      end

      it 'redirects to the profile' do
        profile = Profile.create! valid_attributes
        put :update, {:id => profile.to_param, :profile => valid_attributes}, valid_session
        response.should redirect_to(profile)
      end
    end

    describe 'with invalid params' do
      it 'assigns the profile as @profile' do
        profile = Profile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Profile.any_instance.stub(:save).and_return(false)
        put :update, {:id => profile.to_param, :profile => { 'name' => 'invalid value'}}, valid_session
        assigns(:profile).should eq(profile)
      end

      it "re-renders the 'edit' template" do
        pending
        profile = Profile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Profile.any_instance.stub(:save).and_return(false)
        put :update, {:id => profile.to_param, :profile => { 'name' => 'invalid value'}}, valid_session
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested profile' do
      profile = Profile.create! valid_attributes
      expect {
        delete :destroy, {:id => profile.to_param}, valid_session
      }.to change(Profile, :count).by(-1)
    end

    it 'redirects to the profiles list' do
      profile = Profile.create! valid_attributes
      delete :destroy, {:id => profile.to_param}, valid_session
      response.should redirect_to(profiles_url)
    end
  end

end
