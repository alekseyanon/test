class Api::AgusController < ApplicationController
  respond_to :json

  def search
    @agus = Agu.where(place: true)
    @agus = @agus.search(params[:query])
    @agus = @agus.page params[:page]
    respond_with @agus
  end

end
