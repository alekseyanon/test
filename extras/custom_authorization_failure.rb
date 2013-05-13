# Файл определяет поведение при неудачной авторизации
class CustomAuthorizationFailure < Devise::FailureApp
  def redirect_url
  	# редирект на главную с автоматическим повторным открытием
  	# окна регистрации/авторизации
    root_url(modal: true)
  end

  def respond
    redirect
  end
end
