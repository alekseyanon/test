class ReviewsController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update]
  def new
    @landmark_description = LandmarkDescription.find params[:landmark_description_id]
    @review = @landmark_description.reviews.build
    new!
  end

  def show
    @review = Review.find params[:id]
    @landmark_description = @review.reviewable
    @comment_roots  = @review.comments.roots.order "created_at asc"
  end

  def create
    @landmark_description = LandmarkDescription.find params[:landmark_description_id]
    @review = @landmark_description.reviews.build params[:review]
    @review.user = current_user
    respond_with do |format|
      if @review.save
        format.html { redirect_to @review, notice: 'review was successfully saved.' }
        format.json { head :no_content }
      else
        format.html { render action: :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @review = Review.find params[:id]
    @landmark_description = @review.reviewable

    respond_with do |format|
      if @review.update_attributes(params[:review])
        format.html { redirect_to @review, notice: 'review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end
end
