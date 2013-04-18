require 'spec_helper'

describe GeoObjectsController do

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
      it "assigns all geo_objects as @geo_objects" do
        geo_object = GeoObject.make! valid_attributes
        all = GeoObject.all.to_a
        get :index, {}, valid_session
        assigns(:geo_objects).should eq(all)
      end
    end

    describe "GET show" do
      it "assigns the requested geo_object as @geo_object" do
        geo_object = GeoObject.make! valid_attributes
        get :show, {id: geo_object.id}, valid_session
        response.should be_success
        assigns(:geo_object).should eq(geo_object)
      end
    end
  end

  context 'user' do

    before :each do
      sign_in
    end

    describe "GET new" do
      it "assigns a new geo_object as @geo_object" do
        get :new, {}, valid_session
        assigns(:geo_object).should be_a_new(GeoObject)
      end
    end

    describe "GET edit" do
      it "assigns the requested geo_object as @geo_object" do
        geo_object = GeoObject.make! valid_attributes
        get :edit, {:id => geo_object.to_param}, valid_session
        assigns(:geo_object).should eq(geo_object)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new GeoObject" do
          expect {
            post :create, {:geo_object => valid_attributes}, valid_session
          }.to change(GeoObject, :count).by(1)
        end

        it "assigns a newly created geo_object as @geo_object" do
          post :create, {:geo_object => valid_attributes}, valid_session
          assigns(:geo_object).should be_a(GeoObject)
          assigns(:geo_object).should be_persisted
        end

        it "redirects to the created geo_object" do
          post :create, {:geo_object => valid_attributes}, valid_session
          response.should redirect_to(GeoObject.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved geo_object as @geo_object" do
          # Trigger the behavior that occurs when invalid params are submitted
          GeoObject.any_instance.stub(:save).and_return(false)
          post :create, {:geo_object => {}}, valid_session
          assigns(:geo_object).should be_a_new(GeoObject)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          GeoObject.any_instance.stub(:save).and_return(false)
          post :create, {:geo_object => {}}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested geo_object" do
          va = valid_attributes.update({ xld: "30.456", yld: "56.345" }).with_indifferent_access
          geo_object = GeoObject.make! va
          # Assuming there are no other geo_objects in the database, this
          # specifies that the GeoObject created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.

          GeoObject.any_instance.should_receive(:update_attributes).with(va)
          put :update, {:id => geo_object.to_param, :geo_object => va}, valid_session
        end

        it "assigns the requested geo_object as @geo_object" do
          geo_object = GeoObject.make! valid_attributes
          put :update, {:id => geo_object.to_param, :geo_object => valid_attributes}, valid_session
          assigns(:geo_object).should eq(geo_object)
        end

        it "redirects to the geo_object" do
          geo_object = GeoObject.make! valid_attributes
          put :update, {:id => geo_object.to_param, :geo_object => valid_attributes}, valid_session
          response.should redirect_to(geo_object)
        end
      end

      describe "with invalid params" do
        it "assigns the geo_object as @geo_object" do
          geo_object = GeoObject.make! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          GeoObject.any_instance.stub(:save).and_return(false)
          put :update, {:id => geo_object.to_param, :geo_object => {}}, valid_session
          assigns(:geo_object).should eq(geo_object)
        end

        it "re-renders the 'edit' template" do
          geo_object = GeoObject.make! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          GeoObject.any_instance.stub(:save).and_return(false)
          put :update, {:id => geo_object.to_param, :geo_object => {}}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested geo_object" do
        geo_object = GeoObject.make! valid_attributes
        expect {
          delete :destroy, {:id => geo_object.to_param}, valid_session
        }.to change(GeoObject, :count).by(-1)
      end

      it "redirects to the geo_objects list" do
        geo_object = GeoObject.make! valid_attributes
        delete :destroy, {:id => geo_object.to_param}, valid_session
        response.should redirect_to(geo_objects_url)
      end
    end

  end #context user

end
