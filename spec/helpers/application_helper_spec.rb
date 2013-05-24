require 'spec_helper'

describe ApplicationHelper do
   helper ApplicationHelper

   it "can find location by ip" do
     ip_location('109.194.200.185')['city'].force_encoding('UTF-8').should == 'Киров'
   end
end
