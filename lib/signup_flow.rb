# -*- encoding : utf-8 -*-
module SignupFlow
  def self.included(base)
    base.before_filter :clear_just_signed_up
    base.helper_method :just_signed_up?
    base.extend ClassMethods
  end

  module ClassMethods
    protected

    def keep_signup_flow(options = {})
      skip_before_filter :clear_just_signed_up, options
    end
  end

  protected

  def just_signed_up?
    session[:just_signed_up] || params[:just_signed_up]
  end

  def set_just_signed_up
    session[:just_signed_up] = true
  end

  def clear_just_signed_up
    session[:just_signed_up] = nil if just_signed_up?
  end
end
