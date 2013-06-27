class Api::RatingsController < ApplicationController
  TYPE_TO_SQL = { commentators:   'commentator DESC',
                  bloggers:       'blogger DESC',
                  photographers:  'photographer DESC',
                  experts:        'expert DESC',
                  discoverers:    'discoverer DESC'
  }

  ### api url for user ratings
  # /api/ratings/list.json?page=2
  # /api/ratings/list.json?order_by=commentators
  # /api/ratings/list.json?order_by=bloggers&page=2
  def list
    cond = if (query = params[:order_by].try(:to_sym))
             TYPE_TO_SQL[ query ]
           else
             '(commentator + blogger + photographer + expert + discoverer) DESC'
           end
    @users = User.sorted_list_with_page(cond, params[:page].to_i)
  end
end
