class Api::ChroniclesController < ApplicationController
  #respond_to :json

  def show
    ### TODO: group_by option is turned off
    window = 10
    page = params[:page].to_i
    @objects = GeoObject.order('created_at DESC').limit(10).offset(page*window) #.group_by{|g| g.created_at.strftime('%d %b %y')}
    @objects
  end
end
