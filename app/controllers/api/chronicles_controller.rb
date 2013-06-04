class Api::ChroniclesController < ApplicationController
  #respond_to :json

  def show
    ### TODO: group_by option is turned off
    @objects = GeoObject.first(5) #.group_by{|g| g.created_at.strftime('%d %b %y')}
    @objects
  end
end
