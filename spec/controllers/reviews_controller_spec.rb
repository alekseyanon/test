require 'spec_helper'

describe ReviewsController do
  #before { pending "Waiting for AuthLogic testing helpers to be mastered" }

  let(:user) { User.make! }
  let!(:node) { Osm::Node.make! }
  let!(:ld){LandmarkDescription.make!}

  before :all do
    Category.make!
  end

  # before :each do

  # end

  def valid_attributes
    { title: Faker::Lorem.sentence,
      body:  Faker::Lorem.sentences(10)
    }
  end

  # def valid_session
  #   {}
  # end

  describe "GET index" do
    login_user

    it "assigns all reviews as @reviews" do
      #sign_in user
      review = Review.make! valid_attributes
      get :index, {}
      assigns(:reviews).should eq([review])
    end
  end

  describe "GET show" do
    login_user

    it "assigns the requested review as @review" do

      review = Review.make! valid_attributes
      get :show, {:id => review.to_param}
      assigns(:review).should eq(review)
    end
  end

  describe "GET new" do
    login_user

    it "assigns a new review as @review" do
      get :new, {landmark_description_id: ld.id}
      assigns(:review).should be_a_new(Review)
    end
  end

  describe "GET edit" do
    login_user

    it "assigns the requested review as @review" do
      review = Review.make! valid_attributes
      get :edit, {:id => review.to_param}
      assigns(:review).should eq(review)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      login_user

      it "creates a new Review" do
        expect {
          post :create, landmark_description_id: ld.id, review: valid_attributes
        }.to change(Review, :count).by(1)
      end

      it "assigns a newly created review as @review" do
        post :create, {landmark_description_id: ld.id, :review => valid_attributes}
        assigns(:review).should be_a(Review)
        assigns(:review).should be_persisted
      end

      it "redirects to the created review" do
        post :create, {landmark_description_id: ld.id, :review => valid_attributes}
        response.should redirect_to(ld)
      end
    end

    describe "with invalid params" do
      login_user

      it "assigns a newly created but unsaved review as @review" do
        pending "some thing wrong for invalid attributes"
        # Trigger the behavior that occurs when invalid params are submitted
        Review.any_instance.stub(:save).and_return(false)
        post :create, {landmark_description_id: ld.id, :review => { title: 'invalid value', body: 'test'  }}
        assigns(:review).should be_a_new(Review)
      end

      it "re-renders the 'new' template" do
        pending "some thing wrong for invalid attributes"
        # Trigger the behavior that occurs when invalid params are submitted
        Review.any_instance.stub(:save).and_return(false)
        post :create, {landmark_description_id: ld.id, :review => { }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      login_user

      it "updates the requested review" do
        review = Review.make! valid_attributes
        # Assuming there are no other reviews in the database, this
        # specifies that the Review created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Review.any_instance.should_receive(:update_attributes).with({ "title" => "MyString" })
        put :update, {landmark_description_id: ld.id, :id => review.to_param, :review => { "title" => "MyString" }}
      end

      it "assigns the requested review as @review" do
        review = Review.make! valid_attributes
        put :update, {landmark_description_id: ld.id, :id => review.to_param, :review => valid_attributes}
        assigns(:review).should eq(review)
      end

      it "redirects to the review" do
        review = Review.make! valid_attributes
        put :update, {landmark_description_id: ld.id, :id => review.to_param, :review => valid_attributes}
        response.should redirect_to(review)
      end
    end

    describe "with invalid params" do
      login_user

      it "assigns the review as @review" do
        review = Review.make! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Review.any_instance.stub(:save).and_return(false)
        put :update, {:id => review.to_param, :review => { title: 'invalid value' }}
        assigns(:review).should eq(review)
      end

      it "re-renders the 'edit' template" do
        pending "some thing wrong for invalid attributes"
        review = Review.make! valid_attributes
        Review.any_instance.stub(:save).and_return(false)
        put :update, {:id => review.to_param, :review => { title: '' }}
        require 'pp'
        pp response
        pp current_path
        puts page.html
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_user

    it "destroys the requested review" do
      review = Review.make! valid_attributes
      expect {
        delete :destroy, {:id => review.to_param}
      }.to change(Review, :count).by(-1)
    end

    it "redirects to the reviews list" do
      review = Review.make! valid_attributes
      delete :destroy, {:id => review.to_param}
      response.should redirect_to(reviews_url)
    end
  end

end
