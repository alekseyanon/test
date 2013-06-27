class RatingsController < ApplicationController

  respond_to :html, :json

  TYPE_TO_SQL = { commentators:   'commentator DESC',
                  bloggers:       'blogger DESC',
                  photographers:  'photographer DESC',
                  experts:        'expert DESC',
                  discoverers:    'discoverer DESC'
  }
  def list
    cond = if (query = params[:order_by].try(:to_sym))
             TYPE_TO_SQL[ query ]
           else
             '(commentator + blogger + photographer + expert + discoverer) DESC'
           end
    @users = User.order(cond, 'created_at DESC').page params[:page]
    respond_to do |format|
      format.html
      format.js
      format.json {render json: @users }
    end
  end
end
