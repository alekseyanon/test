class RuntipsController < InheritedResources::Base

  def create
    @geo_object = GeoObject.find(params[:geo_object_id])
    @runtip = @geo_object.runtips.build(params[:runtip])
    @runtip.user = current_user
    @runtip.save
    
    render json: @runtip.to_json
  end

  def index
    render json: GeoObject.find(params[:geo_object_id]).runtips.to_json
  end

end
