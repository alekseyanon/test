class ApplicationController < ActionController::Base
  protect_from_forgery

  def logg str, variable
    logger.debug "#{Time.now} | url - #{request.original_url} | " + "#{variable} | " + str
  end
end
