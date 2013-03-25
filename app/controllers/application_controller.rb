class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :first_time?

  def request_logger params, error_message = ''
    logger.debug "url : #{request.original_url} | params : #{params} | " + error_message
  end

  private

  def first_time?
    if cookies[:first_time].nil?
      cookies[:first_time] = {value: true, expires: 10.years.from_now}
    else
      cookies[:first_time] = {value: false, expires: 10.years.from_now}
    end
  end
end
