class ReviewsController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update]
  def new
    @geo_object = GeoObject.find params[:geo_object_id]
    @review = @geo_object.reviews.build
    new!
  end

  def show
    @review = Review.find params[:id]
    @geo_object = @review.reviewable
    @comment_roots  = @review.comments.roots.order "created_at asc"
  end

  def create
    @geo_object = GeoObject.find params[:geo_object_id]
    @review = @geo_object.reviews.build params[:review]
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
    @geo_object = @review.reviewable

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
