require 'spec_helper'

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

describe LandmarksController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # Landmark. As you add validations to Landmark, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {osm_id: Osm::Node.make!.id, osm_type: 'Osm::Node'}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LandmarksController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all landmarks as @landmarks" do
      landmark = Landmark.create! valid_attributes
      get :index, {}, valid_session
      assigns(:landmarks).should eq([landmark])
    end
  end

  describe "GET show" do
    it "assigns the requested landmark as @landmark" do
      landmark = Landmark.create! valid_attributes
      get :show, {:id => landmark.to_param}, valid_session
      assigns(:landmark).should eq(landmark)
    end
  end

  describe "GET new" do
    it "assigns a new landmark as @landmark" do
      get :new, {}, valid_session
      assigns(:landmark).should be_a_new(Landmark)
    end
  end

  describe "GET edit" do
    it "assigns the requested landmark as @landmark" do
      landmark = Landmark.create! valid_attributes
      get :edit, {:id => landmark.to_param}, valid_session
      assigns(:landmark).should eq(landmark)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Landmark" do
        expect {
          post :create, {:landmark => valid_attributes}, valid_session
        }.to change(Landmark, :count).by(1)
      end

      it "assigns a newly created landmark as @landmark" do
        post :create, {:landmark => valid_attributes}, valid_session
        assigns(:landmark).should be_a(Landmark)
        assigns(:landmark).should be_persisted
      end

      it "redirects to the created landmark" do
        post :create, {:landmark => valid_attributes}, valid_session
        response.should redirect_to(Landmark.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved landmark as @landmark" do
        # Trigger the behavior that occurs when invalid params are submitted
        Landmark.any_instance.stub(:save).and_return(false)
        post :create, {:landmark => {}}, valid_session
        assigns(:landmark).should be_a_new(Landmark)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Landmark.any_instance.stub(:save).and_return(false)
        post :create, {:landmark => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested landmark" do
        landmark = Landmark.create! valid_attributes
        # Assuming there are no other landmarks in the database, this
        # specifies that the Landmark created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Landmark.any_instance.should_receive(:update_attributes).with({'name' => 'other_name'})
        put :update, {id: landmark.to_param, landmark: {:name => 'other_name'}}, valid_session
      end

      it "assigns the requested landmark as @landmark" do
        landmark = Landmark.create! valid_attributes
        put :update, {:id => landmark.to_param, :landmark => valid_attributes}, valid_session
        assigns(:landmark).should eq(landmark)
      end

      it "redirects to the landmark" do
        landmark = Landmark.create! valid_attributes
        put :update, {:id => landmark.to_param, :landmark => valid_attributes}, valid_session
        response.should redirect_to(landmark)
      end
    end

    describe "with invalid params" do
      it "assigns the landmark as @landmark" do
        landmark = Landmark.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Landmark.any_instance.stub(:save).and_return(false)
        put :update, {:id => landmark.to_param, :landmark => {}}, valid_session
        assigns(:landmark).should eq(landmark)
      end

      it "re-renders the 'edit' template" do
        landmark = Landmark.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Landmark.any_instance.stub(:save).and_return(false)
        put :update, {:id => landmark.to_param, :landmark => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested landmark" do
      landmark = Landmark.create! valid_attributes
      expect {
        delete :destroy, {:id => landmark.to_param}, valid_session
      }.to change(Landmark, :count).by(-1)
    end

    it "redirects to the landmarks list" do
      landmark = Landmark.create! valid_attributes
      delete :destroy, {:id => landmark.to_param}, valid_session
      response.should redirect_to(landmarks_url)
    end
  end

end