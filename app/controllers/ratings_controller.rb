class RatingsController < ApplicationController

  respond_to :html, :json

  @@type_to_sql = { commentators:   'commentator DESC',
                  bloggers:       'blogger DESC',
                  photographers:  'photographer DESC',
                  experts:        'expert DESC',
                  discoverers:    'discoverer DESC'
  }
  def list
    @users = User.order(@@type_to_sql[ params[:order_by].try(:to_sym) ]).page params[:page]
    respond_to do |format|
      format.html
      format.js
      format.json {render json: @users }
    end
  end
end
