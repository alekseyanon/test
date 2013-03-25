class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_first_time_cookie

  def request_logger params, error_message = ''
    logger.debug "url : #{request.original_url} | params : #{params} | " + error_message
  end

  private

  def set_first_time_cookie
    cookies[:first_time] = {value: cookies.has_key?(:first_time), expires: 10.years.from_now}
  end

end
