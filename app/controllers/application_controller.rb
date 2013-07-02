class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_first_time_cookie

  def request_logger params, error_message = ''
    logger.debug "url : #{request.original_url} | params : #{params} | " + error_message
  end

  def find_parent_model
    [[:comment_id, Comment],
     [:runtip_id, Runtip],
     [:review_id, Review],
     [:image_id, Image],
     [:event_id, Event],
     [:object_id, GeoObject], #TODO привести к одному виду routes 4 GeoObject
     [:geo_object_id, GeoObject]
    ].each do |(key, parent_class)|
      return @parent = parent_class.find(params[key]) if params.has_key? key
    end
  end

  def load_search_history
    @search_history = SearchQuery.history_for_user(current_user)
  end

  private

  def set_first_time_cookie
    cookies[:first_time] = {value: cookies.has_key?(:first_time), expires: 10.years.from_now}
  end

end
