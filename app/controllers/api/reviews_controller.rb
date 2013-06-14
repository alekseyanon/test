class Api::ReviewsController < ApplicationController
  
  def create
    @geo_object = GeoObject.find params[:object_id]
    @review = @geo_object.reviews.build params[:review]
    @review.user = current_user
    @review.save
    @review
  end

  def update
  end

  def destroy
  end

  def show
  end

  def index
    @reviews = GeoObject.find(params[:object_id]).reviews
  end

end
