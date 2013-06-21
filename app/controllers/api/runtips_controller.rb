class Api::RuntipsController < ApplicationController
  
  def create
    @geo_object = GeoObject.find(params[:geo_object_id])
    @runtip = @geo_object.runtips.build(params[:runtip])
    @runtip.user = current_user
    @runtip.save
    @runtip
  end

  def update
  end

  def destroy
  end

  def show
  end

  def index
    @runtips = GeoObject.find(params[:geo_object_id]).runtips
  end

end
