class Api::ObjectsController < ApplicationController

  def nearby
    r = params[:r] || 50
    @objects = GeoObject.find(params[:id]).objects_nearby(r)
    render json: @objects
  end

  def show
    ld = GeoObject.find params[:id]
    render json: ld.to_json( extra: { teaser: params[:teaser] } )
  end

end
