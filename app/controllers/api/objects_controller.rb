class Api::ObjectsController < ApplicationController

  def nearby
    r = params[:r] || 50
    object = LandmarkDescription.find params[:id]
    @objects = LandmarkDescription.where("abstract_descriptions.id <> #{object.id}").within_radius object.describable.osm.geom, r
    render json: @objects
  end

end
