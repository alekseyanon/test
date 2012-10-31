# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class Notifier < ActionMailer::Base
  default from: "noreply@travel.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.signup_confirmation.subject
  #
  def signup_confirmation(user)
    @user = user

    mail to: user.email, subject: "Подтверждение регистрации"
  end
end
