class Api::AgusController < ApplicationController
  respond_to :json

  def search
    @agus = Agu.where(place: true).search(params[:query]).page(params[:page])
    respond_with @agus
  end

end
