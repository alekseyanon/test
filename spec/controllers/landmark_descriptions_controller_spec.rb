require 'spec_helper'
require 'authlogic/test_case'

include Authlogic::TestCase

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe LandmarkDescriptionsController do
  setup :activate_authlogic
  let(:user) { User.make! }
  let!(:node) { Osm::Node.make! }
  before :all do
    Category.make!
  end
  before :each do
    login
  end


  # This should return the minimal set of attributes required to create a valid
  # LandmarkDescription. As you add validations to LandmarkDescription, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { title: Faker::Lorem.sentence,
      body:  Faker::Lorem.sentences(10),
      published: [true, false].sample,
      published_at: Time.now.to_s
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LandmarkDescriptionsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all landmark_descriptions as @landmark_descriptions" do
      landmark_description = LandmarkDescription.make! valid_attributes
      all = LandmarkDescription.all.to_a
      get :index, {}, valid_session
      assigns(:landmark_descriptions).should eq(all)
    end
  end

  describe "GET show" do
    it "assigns the requested landmark_description as @landmark_description" do
      landmark_description = LandmarkDescription.make! valid_attributes
      get :show, {:id => landmark_description.to_param}, valid_session
      assigns(:landmark_description).should eq(landmark_description)
    end
  end
  describe "GET new" do
    it "assigns a new landmark_description as @landmark_description" do
      get :new, {}, valid_session
      assigns(:landmark_description).should be_a_new(LandmarkDescription)
    end
  end

  describe "GET edit" do
    it "assigns the requested landmark_description as @landmark_description" do
      landmark_description = LandmarkDescription.make! valid_attributes
      get :edit, {:id => landmark_description.to_param}, valid_session
      assigns(:landmark_description).should eq(landmark_description)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before { pending "Waiting for AuthLogic testing helpers to be mastered" }
      it "creates a new LandmarkDescription" do
        expect {
          post :create, {:landmark_description => valid_attributes}, valid_session
        }.to change(LandmarkDescription, :count).by(1)
      end

      it "assigns a newly created landmark_description as @landmark_description" do
        post :create, {:landmark_description => valid_attributes}, valid_session
        assigns(:landmark_description).should be_a(LandmarkDescription)
        assigns(:landmark_description).should be_persisted
      end

      it "redirects to the created landmark_description" do
        post :create, {:landmark_description => valid_attributes}, valid_session
        response.should redirect_to(LandmarkDescription.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved landmark_description as @landmark_description" do
        # Trigger the behavior that occurs when invalid params are submitted
        LandmarkDescription.any_instance.stub(:save).and_return(false)
        post :create, {:landmark_description => {}}, valid_session
        assigns(:landmark_description).should be_a_new(LandmarkDescription)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        LandmarkDescription.any_instance.stub(:save).and_return(false)
        post :create, {:landmark_description => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before do
        
      end

      it "updates the requested landmark_description" do
        va = valid_attributes.update({ xld: "30.456", yld: "56.345" }).with_indifferent_access
        landmark_description = LandmarkDescription.make! va
        # Assuming there are no other landmark_descriptions in the database, this
        # specifies that the LandmarkDescription created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.

        LandmarkDescription.any_instance.should_receive(:update_attributes).with(va)
        put :update, {:id => landmark_description.to_param, :landmark_description => va}, valid_session
      end

      it "assigns the requested landmark_description as @landmark_description" do
        landmark_description = LandmarkDescription.make! valid_attributes
        put :update, {:id => landmark_description.to_param, :landmark_description => valid_attributes}, valid_session
        assigns(:landmark_description).should eq(landmark_description)
      end

      it "redirects to the landmark_description" do
        landmark_description = LandmarkDescription.make! valid_attributes
        put :update, {:id => landmark_description.to_param, :landmark_description => valid_attributes}, valid_session
        response.should redirect_to(landmark_description)
      end
    end

    describe "with invalid params" do
      it "assigns the landmark_description as @landmark_description" do
        landmark_description = LandmarkDescription.make! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LandmarkDescription.any_instance.stub(:save).and_return(false)
        put :update, {:id => landmark_description.to_param, :landmark_description => {}}, valid_session
        assigns(:landmark_description).should eq(landmark_description)
      end

      it "re-renders the 'edit' template" do
        landmark_description = LandmarkDescription.make! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        LandmarkDescription.any_instance.stub(:save).and_return(false)
        put :update, {:id => landmark_description.to_param, :landmark_description => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested landmark_description" do
      landmark_description = LandmarkDescription.make! valid_attributes
      expect {
        delete :destroy, {:id => landmark_description.to_param}, valid_session
      }.to change(LandmarkDescription, :count).by(-1)
    end

    it "redirects to the landmark_descriptions list" do
      landmark_description = LandmarkDescription.make! valid_attributes
      delete :destroy, {:id => landmark_description.to_param}, valid_session
      response.should redirect_to(landmark_descriptions_url)
    end
  end

end
