class ApplicationController < ActionController::Base
  protect_from_forgery

  delegate :allow?, to: :current_permission
  helper_method :allow?

  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?

  before_filter :set_first_time_cookie

  def request_logger params, error_message = ''
    logger.debug "url : #{request.original_url} | params : #{params} | " + error_message
  end

  def find_parent_model
    [[:comment_id, Comment],
     [:review_id, Review],
     [:image_id, Image],
     [:event_id, Event],
     [:geo_object_id, GeoObject]].each do |(key, parent_class)|
      return @parent = parent_class.find(params[key]) if params.has_key? key
    end
  end

  private

  def current_permission
    @current_permission ||= Permission.new(current_user)
  end

  def current_resource
    nil
  end

  def authorize
    unless current_permission.allow?(params[:controller], params[:action], current_resource)
      redirect_to root_url, alert: "Not authorized."
    end
  end

  def set_first_time_cookie
    cookies[:first_time] = {value: cookies.has_key?(:first_time), expires: 10.years.from_now}
  end

end
