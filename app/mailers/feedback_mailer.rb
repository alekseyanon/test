# -*- encoding : utf-8 -*-
class FeedbackMailer < ActionMailer::Base
  default from: 'monax.spam@gmail.com'

  def feedback_information(args)
    @email, @name, @content = args.values
    mail to: 'igor.karmazin@gmail.com', subject: 'Обратная связь Smorodina.com'
  end
end
