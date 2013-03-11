require 'spec_helper'

describe LandmarkDescriptionsController do

  ### TODO: make with devse helper methods
  let(:user) { User.make! }
  let!(:node) { Osm::Node.make! }

  before :all do
    Category.make!
  end

  def valid_attributes
    { title: Faker::Lorem.sentence,
      body:  Faker::Lorem.sentences(10),
      published: [true, false].sample,
      published_at: Time.now.to_s
    }
  end

  def valid_session
    {}
  end

  context 'anonymous' do
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
        get :show, {id: landmark_description.id}, valid_session
        response.should be_success
        assigns(:landmark_description).should eq(landmark_description)
      end
    end
  end

  context 'user' do

    before :each do
      sign_in
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

  end #context user

end
