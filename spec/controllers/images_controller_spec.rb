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

describe ImagesController do
  # This should return the minimal set of attributes required to create a valid
  # Image. As you add validations to Image, be sure to
  # update the return value of this method accordingly.
  let(:user) { User.make! }
  let!(:node) { Osm::Node.make! }
  let!(:ld){GeoObject.make!}
  let!(:geo_object){GeoObject.make!}

  before :all do
    Category.make!
  end
  login_user

  def valid_attributes
    { image: fixture_file_upload('/images/fishing/toon376.gif', 'image/gif') }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ImagesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all images as @images" do
      image = Image.make! valid_attributes
      get :index, {geo_object_id: image.imageable_id}
      assigns(:images).should eq([image])
    end
  end

  describe "GET show" do
    it "assigns the requested image as @image" do
      image = Image.make! valid_attributes
      get :show, {id: image.to_param, geo_object_id: image.imageable_id}
      assigns(:image).should eq(image)
    end
  end

  describe "GET new" do
    it "assigns a new image as @image" do
      get :new, {geo_object_id: geo_object.id}
      assigns(:image).should be_a_new(Image)
    end
  end

  describe "GET edit" do
    it "assigns the requested image as @image" do
      image = Image.make! valid_attributes
      get :edit, {id: image.to_param, geo_object_id: image.imageable_id}
      assigns(:image).should eq(image)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Image" do
        expect {
          post :create, {image: valid_attributes, geo_object_id: geo_object.id}
        }.to change(Image, :count).by(1)
      end

      it "assigns a newly created image as @image" do
        post :create, {image: valid_attributes, geo_object_id: geo_object.id}
        assigns(:image).should be_a(Image)
        assigns(:image).should be_persisted
      end

      it "redirects to the created image" do
        post :create, {image: valid_attributes, geo_object_id: geo_object.id}
        response.should redirect_to(geo_object_image_path(geo_object, Image.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved image as @image" do
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        post :create, {image: { "image" => "invalid value" }, geo_object_id: geo_object.id}
        assigns(:image).should be_a_new(Image)
      end

      it "re-renders the 'new' template" do
        pending 'will be fixed later'
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        Image.any_instance.stub(:errors).and_return(['error'])
        post :create, {image: { "image" => "invalid value" }, geo_object_id: geo_object.id}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested image" do
        image = Image.make! valid_attributes
        # Assuming there are no other images in the database, this
        # specifies that the Image created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Image.any_instance.should_receive(:update_attributes).with({ "image" => "MyString" })
        put :update, {id: image.to_param, image: { "image" => "MyString" }, geo_object_id: image.imageable_id}
      end

      it "assigns the requested image as @image" do
        image = Image.make! valid_attributes
        put :update, {id: image.to_param, image: valid_attributes, geo_object_id: image.imageable_id}
        assigns(:image).should eq(image)
      end

      it "redirects to the image" do
        image = Image.make! valid_attributes
        put :update, {id: image.to_param, image: valid_attributes, geo_object_id: image.imageable_id}
        response.should redirect_to(image)
      end
    end

    describe "with invalid params" do
      it "assigns the image as @image" do
        image = Image.make! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        put :update, {id: image.to_param, image: { "image" => "invalid value" }, geo_object_id: image.imageable_id}
        assigns(:image).should eq(image)
      end

      it "re-renders the 'edit' template" do
        pending 'will be fixed later'
        image = Image.make! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        Image.any_instance.stub(:errors).and_return(['error'])
        put :update, {id: image.to_param, image: { "image" => "invalid value" }, geo_object_id: image.imageable_id}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested image" do
      image = Image.make! valid_attributes
      expect {
        delete :destroy, {id: image.to_param, geo_object_id: image.imageable_id}
      }.to change(Image, :count).by(-1)
    end

    it "redirects to the images list" do
      image = Image.make! valid_attributes
      delete :destroy, {id: image.to_param, geo_object_id: image.imageable_id}
      response.should redirect_to(images_url)
    end
  end

end
