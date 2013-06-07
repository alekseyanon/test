class Api::ChroniclesController < ApplicationController
  def show
    window = 10
    page = params[:page].to_i
    @objects = GeoObject.order('created_at DESC').limit(10).offset(page*window)
    @objects
  end
end
