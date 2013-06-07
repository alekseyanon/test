class Api::ChroniclesController < ApplicationController
  def show
    window = CHRONICLE_PAGINATION_ITEMS
    page = params[:page].to_i
    @objects = GeoObject.order('created_at DESC').limit(window).offset(page*window)
    @objects
  end
end
