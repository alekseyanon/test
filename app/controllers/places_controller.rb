class PlacesController < ApplicationController
  def show
    @object = Agu.find(params[:id])
  end
end
