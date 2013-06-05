class Api::ChroniclesController < ApplicationController
  #respond_to :json

  def show
    ### TODO: group_by option is turned off
    window = 5
    page = params[:page].to_i
    @objects = GeoObject.limit(5).offset(page*window) #.group_by{|g| g.created_at.strftime('%d %b %y')}
    @objects
  end
end
