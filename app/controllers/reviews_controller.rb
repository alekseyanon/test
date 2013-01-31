class ReviewsController < InheritedResources::Base
  def new
    @landmark_description = LandmarkDescription.find params[:landmark_description_id]
    @review = @landmark_description.reviews.build
    new!
  end

  def create
    @landmark_description = LandmarkDescription.find params[:landmark_description_id]
    @review = @landmark_description.reviews.build params[:review]
    @review.user = current_user
    @review.save!
    redirect_to @landmark_description
  end

  def make_vote
    review = Review.find(params[:id])
    (params[:sign] == "up") ? 
        current_user.vote_exclusively_for(review) : 
        current_user.vote_exclusively_against(review)
    if (current_user.voted_on?(review))
      render json: { positive: "#{review.votes_for}", negative: "#{review.votes_against}" }
    else
      render json: {error: "something wrong, please, try again"}  
    end
  end
end
