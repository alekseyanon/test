class RatingsController < ApplicationController

  respond_to :html, :json

  @@type_to_sql = { commentators:   'commentator DESC',
                  bloggers:       'blogger DESC',
                  photographers:  'photographer DESC',
                  experts:        'expert DESC',
                  discoverers:    'discoverer DESC'
  }
  def list
    cond = if query = params[:order_by]
             @@type_to_sql[ query.try(:to_sym) ]
           else
             '(commentator + blogger + photographer + expert + discoverer) DESC'
           end
    @users = User.order(cond + ', created_at DESC').page params[:page]
    respond_to do |format|
      format.html
      format.js
      format.json {render json: @users }
    end
  end
end
