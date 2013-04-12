class Api::ObjectsController < ApplicationController

  def nearby
    r = params[:r] || 50
    @objects = LandmarkDescription.find(params[:id]).objects_nearby(r)
    render json: @objects
  end

end
