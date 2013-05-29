class Api::CommentsController < ApplicationController
  
  def create
  end

  def update
  end

  def destroy
  end

  def show
  end

  def index
    @comments = GeoObject.find(params[:object_id]).reviews
                         .find(params[:review_id]).comments
  end

end
