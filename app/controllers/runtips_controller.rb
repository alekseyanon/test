class RuntipsController < InheritedResources::Base
  before_filter :authorize # TODO move to ApplicationController

  def create
    @geo_object = GeoObject.find(params[:geo_object_id])
    @runtip = @geo_object.runtips.build(params[:runtip])
    @runtip.user = current_user
    @runtip.save
    
    render json: @runtip.to_json
  end

  def index
    sleep 1
    render json: GeoObject.find(params[:geo_object_id]).runtips.to_json
  end

end
