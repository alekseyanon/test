require 'spec_helper'

describe "Geo::Landmarks" do
  describe "GET /geo_landmarks" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get geo_landmarks_path
      response.status.should be(200)
    end
  end
end
