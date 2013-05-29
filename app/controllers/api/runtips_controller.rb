class Api::RuntipsController < ApplicationController
  
  def create
  end

  def update
  end

  def destroy
  end

  def show
  end

  def index
    @runtips = GeoObject.find(params[:object_id]).runtips
  end

end
