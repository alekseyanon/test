require 'spec_helper'

describe CommentsController do
  #before { pending "Waiting for AuthLogic testing helpers to be mastered" }

  let(:user) { User.make! }
  let!(:node) { Osm::Node.make! }
  let!(:ld){GeoObject.make!}
  let!(:review){Review.make!}

  before :all do
    Category.make!
    # GeoObject.make!
    # @review = Review.make!
  end
  login_user

  def valid_attributes
    { "body" => "MyText" }
  end

  describe "GET index" do
    it "assigns all comments as @comments" do
      comment = Comment.make! valid_attributes
      get :index, {review_id: comment.commentable_id}
      assigns(:comments).should eq([comment])
    end
  end

  describe "GET show" do
    it "assigns the requested comment as @comment" do
      comment = Comment.make! valid_attributes
      get :show, {id: comment.to_param, review_id: comment.commentable_id}
      assigns(:comment).should eq(comment)
    end
  end

  describe "GET new" do
    it "assigns a new comment as @comment" do
      get :new, {review_id: Review.last.id}
      assigns(:comment).should be_a_new(Comment)
    end
  end

  describe "GET edit" do
    it "assigns the requested comment as @comment" do
      comment = Comment.make! valid_attributes
      get :edit, {id: comment.to_param, review_id: comment.commentable_id}
      assigns(:comment).should eq(comment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, {comment: valid_attributes, review_id: Review.last.id}
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        pending 'problem with inherited resources + nested resources '
        post :create, {comment: valid_attributes, review_id: review.id}
        assigns(:comment).should be_a(Comment)
        assigns(:comment).should be_persisted
      end

      it "redirects to the created comment" do
        post :create, {comment: valid_attributes, review_id: review}
        response.should redirect_to(Review.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        pending 'problem with inherited resources + nested resources '
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        Comment.any_instance.stub(:errors).and_return(['error'])
        post :create, {comment: { "body" => "invalid value" }, review_id: Review.last.id}
        assigns(:comment).should be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        pending 'problem with inherited resources + nested resources '
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        Comment.any_instance.stub(:errors).and_return(['error'])
        post :create, {comment: { "body" => "invalid value" }, review_id: review.id}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested comment" do
        pending 'problem with inherited resources + nested resources '
        comment = Comment.make! valid_attributes
        # Assuming there are no other comments in the database, this
        # specifies that the Comment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Comment.any_instance.should_receive(:update_attributes).with({ "body" => "MyText" })
        put :update, review_id: comment.commentable_id, id: comment.to_param, comment: { "body" => "MyText" }
      end

      it "assigns the requested comment as @comment" do
        comment = Comment.make! valid_attributes
        put :update, {id: comment.to_param, comment: valid_attributes, review_id: comment.commentable_id}
        assigns(:comment).should eq(comment)
      end

      it "redirects to the comment" do
        comment = Comment.make! valid_attributes
        put :update, {id: comment.to_param, comment: valid_attributes, review_id: comment.commentable_id}
        response.should redirect_to(root_url)
      end
    end

    describe "with invalid params" do
      it "assigns the comment as @comment" do
        comment = Comment.make! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        Comment.any_instance.stub(:errors).and_return(['error'])
        put :update, {id: comment.to_param, comment: { "body" => "invalid value" }, review_id: comment.commentable_id}
        assigns(:comment).should eq(comment)
      end

      it "re-renders the 'edit' template" do
        pending 'problem with inherited resources + nested resources '
        comment = Comment.make! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        #Comment.any_instance.stub(:errors).and_return(['error'])
        put :update, {id: comment.to_param, comment: { "body" => "invalid value" }, review_id: comment.commentable_id}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested comment" do
      comment = Comment.make! valid_attributes
      expect {
        delete :destroy, {id: comment.to_param, review_id: comment.commentable_id}
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the comments list" do
      comment = Comment.make! valid_attributes
      delete :destroy, {id: comment.to_param, review_id: Review.last.id}
      response.should redirect_to(root_url)
    end
  end

end
