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
    @runtips = GeoObject.find(params[:object_id]).comments
  end

end
