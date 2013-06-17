class Api::ChroniclesController < ApplicationController
  def show
    window = CHRONICLE_PAGINATION_ITEMS
    offset = params[:offset].to_i
    @objects = (newest = GeoObject.newest).limit(window).offset(offset)
    unless @objects.blank?
      unless @objects.group_by{|g| g.day_creation}.values.last.count % 2 == 0
        go = newest.offset(offset+window).first
        @objects.push go if go.try(:day_creation) == @objects.last.day_creation
      end
    end
    @offset = offset + @objects.size
  end
end
