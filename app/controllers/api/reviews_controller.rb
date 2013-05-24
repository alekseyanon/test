class Api::ReviewsController < ApplicationController
  
  def create
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
