# -*- encoding : utf-8 -*-
class Api::ChroniclesController < ApplicationController

  before_filter :get_offsets, :get_agu, only: :show

  ## api url
  # api/chronicles/show.json
  # api/chronicles/show.json?event_offset=4&go_offset=4
  # api/chronicles/show.json?type=geo_object&go_offset=4
  # api/chronicles/show.json?type=event&event_offset=4
  # api/chronicles/show.json?text=test
  # api/chronicles/show.json?type=event&event_offset=4&text=test
  def show
    if params[:text].present? && !@agu
      @objects = []
    else
      @objects, @end_collection = find_objects filter_type_params(params[:type])
      @go_offset += (go_count = @objects.select{|item| item.is_a? GeoObject}.size)
      @event_offset += @objects.size - go_count
    end
  end

  private

  def get_agu
    @agu = Agu.find_by_title(params[:text]).try(:id)
  end

  def get_offsets
    @go_offset = params[:go_offset].to_i
    @event_offset = params[:event_offset].to_i
  end

  def filter_type_params(type)
    (%w(event geo_object).include? type) ? type : nil
  end

  def find_objects klass = nil
    @window = CHRONICLE_PAGINATION_ITEMS
    if klass.present?
      offset = (klass == 'event')? @event_offset : @go_offset
      get_objects offset, klass.classify.constantize
    else
      get_all_objects
    end
  end

  def get_objects(offset, klass)
    chain = klass.newest.limit(@window+2).offset(offset)
    chain = chain.in_place(@agu) if @agu.present?
    chain = chain.visible if klass == Event
    @objects = chain
    list_objects
  end

  def get_all_objects
    go_list = GeoObject.newest_list(@window + 2, @go_offset)
    event_list = Event.newest_list(@window + 2, @event_offset).visible
    event_list, go_list = [event_list, go_list].map{ |i| i.in_place(@agu)} if @agu.present?
    @objects = go_list + event_list
    @objects.sort_by!{|obj| -obj.created_at.to_i}
    list_objects
  end

  def list_objects
    end_collection = true
    if @objects.size > @window
      enlarge_window_if_required
      end_collection = false if @objects[@window].present?
    end
    [@objects.first(@window), end_collection]
  end

  def enlarge_window_if_required
    if @objects.first(@window).group_by { |o| o.day_creation }.values.last.count.odd? &&
        @objects[@window - 1].day_creation == @objects[@window].day_creation
      @window += 1
    end
  end
end
