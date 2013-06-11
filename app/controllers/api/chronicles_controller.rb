class Api::ChroniclesController < ApplicationController
  def show
    window = CHRONICLE_PAGINATION_ITEMS
    offset = params[:offset].to_i
    @objects = GeoObject.newest.limit(window).offset(offset).to_a
    unless @objects.group_by{|g| g.created_at.strftime('%d %b %y')}.values.last.count % 2 == 0
      @objects.concat GeoObject.newest.limit(1).offset(offset+window)
    end
    @objects
  end
end
