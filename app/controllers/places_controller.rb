class PlacesController < ApplicationController
  def show
    @object = Agu.find(params[:id])
    centre = @object.geom.centroid
    @x, @y = centre.x, centre.y
  end
end
