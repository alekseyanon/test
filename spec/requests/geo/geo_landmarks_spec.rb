require 'spec_helper'

describe "Landmarks" do #TODO move from geo, fill in some tests
  describe "GET /landmarks" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get landmarks_path
      response.status.should be(200)
    end
  end
end
