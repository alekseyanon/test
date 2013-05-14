# -*- encoding : utf-8 -*-
class FeedbackMailer < ActionMailer::Base
  default from: 'monax.spam@gmail.com'

  def feedback_information(email, name, content)
    @email = email
    @name = name
    @content = content
    mail to: 'lvl0nax@gmail.com', subject: 'Обратная связь Smorodina.com'
  end
end
