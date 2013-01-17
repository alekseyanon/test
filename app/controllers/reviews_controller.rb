class ReviewsController < InheritedResources::Base
  def new
    @landmark_description = LandmarkDescription.find params[:landmark_description_id]
    @review = @landmark_description.reviews.build
    new!
  end

  def create
    @landmark_description = LandmarkDescription.find params[:landmark_description_id]
    @review = @landmark_description.reviews.create params[:review]
    redirect_to @landmark_description
  end
end
