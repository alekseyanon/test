class Api::ChroniclesController < ApplicationController

  ## api url
  # api/chronicles/show.json
  # api/chronicles/show.json?type=geo_object&go_offset=4
  # api/chronicles/show.json?type=event&event_offset=4
  def show
    go_offset = params[:go_offset].to_i
    event_offset = params[:event_offset].to_i
    @objects = if (klass = params[:type])
                 offset = (klass == 'event')? event_offset : go_offset
                 get_objects(offset, klass.classify.constantize)
               else
                 get_all_objects(go_offset, event_offset)
               end
    @go_offset = go_offset + (go_count = @objects.select{|item| item.class == GeoObject}.size)
    @event_offset = event_offset + @objects.size - go_count
  end

  private
  def get_objects(offset, klass, window = CHRONICLE_PAGINATION_ITEMS)
    objects = (newest = klass.newest).limit(window).offset(offset)
    if objects.present? && objects.group_by{|g| g.day_creation}.values.last.count.odd?
      obj = newest.offset(offset+window).first
      objects.push obj if obj.try(:day_creation) == objects.last.day_creation
    end
    objects
  end

  def get_all_objects(go_offset, event_offset, window = CHRONICLE_PAGINATION_ITEMS)
    objects = GeoObject.newest_list(window, go_offset) + Event.newest_list(window, event_offset)
    objects.sort!{|x,y| x.created_at <=> y.created_at}.reverse!
    if objects.present? &&
            objects.first(CHRONICLE_PAGINATION_ITEMS).group_by { |o| o.day_creation }.values.last.count.odd?
      window += 1
    end
    objects.first(window)
  end
end
