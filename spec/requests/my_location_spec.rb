# -*- encoding : utf-8 -*-
require 'spec_helper'

#  Requester IP patching. Accepted from
#  http://stackoverflow.com/questions/2996446/how-do-i-mock-an-ip-address-in-cucumber-capybara
# 
class ApplicationController
	before_filter :mock_ip_address
  def mock_ip_address
    if Rails.env == 'test'
      test_ip = ENV['RAILS_TEST_IP_ADDRESS']
      unless test_ip.nil? or test_ip.empty?
        request.instance_eval <<-EOS
          def remote_ip
            "#{test_ip}"
          end
        EOS
      end
    end
  end
end


describe "Determining user location based on its IP address", js: true, type: :request do
  
  KNOWN_HOSTS = { '91.201.205.23' => [ 'Братск', [56.158553, 101.57135]],
                  '193.19.110.42' => [ 'Киев',   [50.450509, 30.539246]],
                  '91.201.211.23' => [ 'Ярославль',  [57.642461, 39.884491]],
                  '188.92.0.13'   => [ 'Красноярск', [56.016424, 92.851639]] }
	DELTA = 0.01
  
  before(:all) do
  	KNOWN_HOSTS.each_value do |v|
  		Agu.create title: v[0], geom: "POLYGON((#{v[1][0]} #{v[1][1]},
  		                                        #{v[1][0] + DELTA} #{v[1][1]},
  		                                        #{v[1][0] + DELTA} #{v[1][1] + DELTA},
  		                                        #{v[1][0]} #{v[1][1] + DELTA},
  		                                        #{v[1][0]} #{v[1][1]} ))"
		end
  end

	it "determines location based on the city the visitor might be located in" do
		ENV['RAILS_TEST_IP_ADDRESS'] = '91.201.205.23'
		visit root_path
		find('.leaflet-control-my-location').click

		sleep 2

		map_lat, map_lng  = page.evaluate_script "$('.map').data('coords')"

    map_lat.should be_within(DELTA).of 56.158553

    map_lng.should be_within(DELTA).of 101.57135
    
	end
  
end
