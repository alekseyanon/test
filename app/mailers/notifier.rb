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
    @recipient = user
    @header_key = "user_pending_activation_just_signed_up"
    mail to: user.email, subject: "Подтверждение регистрации"
  end

  def user_pending_activation_after_email_update(user)
    @recipient = user
    @header_key = "user_pending_activation_after_email_update"

    mail(:to => user.email, :subject => "Смена e-mail")
  end

  def user_activated(user)
    @recipient = user
    @header_key = "user_activated"

    mail(:to => user.email, :subject => "Вы успешно зарегистрировались!")
  end
end
