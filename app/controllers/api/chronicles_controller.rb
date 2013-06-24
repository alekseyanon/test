class Api::ChroniclesController < ApplicationController

  ## api url
  # api/chronicles/show.json
  # api/chronicles/show.json?event_offset=4&go_offset=4
  # api/chronicles/show.json?type=geo_object&go_offset=4
  # api/chronicles/show.json?type=event&event_offset=4
  # api/chronicles/show.json?text=test
  # api/chronicles/show.json?type=event&event_offset=4&text=test
  def show
    window = CHRONICLE_PAGINATION_ITEMS
    go_offset = params[:go_offset].to_i
    event_offset = params[:event_offset].to_i
    text = params[:text]
    agu = Agu.find_by_title(text)
    @objects = if (klass = params[:type]).present?
                 offset = (klass == 'event')? event_offset : go_offset
                 get_objects(offset, klass.classify.constantize, window, text)
               else
                 get_all_objects(go_offset, event_offset, window, text)
               end
    @go_offset = go_offset + (go_count = @objects.select{|item| item.is_a? GeoObject}.size)
    @event_offset = event_offset + @objects.size - go_count
  end

  private
  def get_objects(offset, klass, window, text = nil)
    newest = klass.newest
    newest = newest.text_search(text) if text.present?
    objects = newest.limit(window).offset(offset)
    if objects.present? && objects.group_by{|g| g.day_creation}.values.last.count.odd?
      obj = newest.offset(offset+window).first
      objects.push obj if obj.try(:day_creation) == objects.last.day_creation
    end
    objects
  end

  def get_all_objects(go_offset, event_offset, window, text = nil)
    go_list = GeoObject.newest_list(window + 1, go_offset)
    event_list = Event.newest_list(window + 1, event_offset)
    event_list, go_list = [event_list, go_list].map{ |i| i.text_search(text)} if text.present?
    objects = go_list + event_list
    objects.sort_by!{|obj| obj.created_at}.reverse!
    if objects.present? && objects.size > window &&
            objects.first(window).group_by { |o| o.day_creation }.values.last.count.odd? &&
            objects[window].present? &&
            objects.last.day_creation == objects[window].day_creation
      window += 1
    end
    objects.first window
  end
end
