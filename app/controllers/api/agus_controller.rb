class Api::AgusController < ApplicationController
  respond_to :json

  def search
    @agus = Agu.where(place: true).search(params[:query]).page(params[:page])
    respond_with @agus
  end

  def search_autocomplete
    @agus = Agu.where(place: true).limit(7).search(params[:query])
  end

end
