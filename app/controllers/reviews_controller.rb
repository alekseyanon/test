class ReviewsController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update]
  def new
    @landmark_description = LandmarkDescription.find params[:landmark_description_id]
    @review = @landmark_description.reviews.build
    new!
  end

  def show
    @review = Review.find params[:id]
    @comment_roots  = @review.comments.roots.order "created_at asc"
  end

  def create
    @landmark_description = LandmarkDescription.find params[:landmark_description_id]
    @review = @landmark_description.reviews.build params[:review]
    @review.user = current_user
    @review.save!
    redirect_to @landmark_description
  end
end
