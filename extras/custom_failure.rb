class CustomFailure < Devise::FailureApp
  def redirect_url
    root_url(modal: true)
  end

  def respond
    redirect
  end
end
