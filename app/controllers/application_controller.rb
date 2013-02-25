class ApplicationController < ActionController::Base
  protect_from_forgery

  def logg str, variable
    logger.debug "========================================================="
    logger.debug str
    logger.debug variable
    logger.debug "========================================================="
  end
end
