class RuntipsController < InheritedResources::Base
	before_filter :authorize # TODO move to ApplicationController

	def create
    @geo_object = GeoObject.find(params[:geo_object_id])
    @runtip = @geo_object.runtips.build(params[:runtip])
    @runtip.user = current_user
    @runtip.save
    redirect_to geo_object_path(@geo_object)
  end

end
