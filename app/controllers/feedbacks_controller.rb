class FeedbacksController < ApplicationController
  def send_feedback
    FeedbackMailer.feedback_information(params[:feedback]).deliver
    redirect_to :back
  end
end
