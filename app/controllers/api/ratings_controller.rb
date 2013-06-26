class Api::RatingsController < ApplicationController
  @@type_to_sql = { commentators:   'commentator DESC',
                    bloggers:       'blogger DESC',
                    photographers:  'photographer DESC',
                    experts:        'expert DESC',
                    discoverers:    'discoverer DESC'
  }
  def list
    cond = if query = params[:order_by].try(:to_sym)
             @@type_to_sql[ query ]
           else
             '(commentator + blogger + photographer + expert + discoverer) DESC'
           end
    @users = User.order(cond, 'created_at DESC').page params[:page]
  end
end
