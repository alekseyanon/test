class ApplicationController < ActionController::Base
  protect_from_forgery

  def request_logger params, error_message = ''
    logger.debug "url : #{request.original_url} | params : #{params} | " + error_message
  end
end
