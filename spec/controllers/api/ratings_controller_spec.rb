# encoding: utf-8
require 'spec_helper'

describe Api::RatingsController do
  render_views
  describe 'GET list of users' do
    let!(:commentator) {User.make! commentator: 3}
    let!(:photographer) {User.make! photographer: 4}

    def get_users_list order_type = nil
      get :list, {format: :json}.merge( order_type ? {order_by: order_type} : {})
      JSON.parse(response.body)
    end

    it 'sorted by photographer rating' do
      resp = get_users_list('photographers')
      resp[0]['id'].should == photographer.id
    end

    it 'sorted by commentator rating' do
      resp = get_users_list('commentators')
      resp[0]['id'].should == commentator.id
    end

    it 'sorted by total rating' do
      resp = get_users_list
      resp[0]['id'].should == photographer.id
    end
  end

end
