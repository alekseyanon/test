require 'spec_helper'

describe "geo/landmarks/index" do
  before(:each) do
    assign(:geo_landmarks, [
      stub_model(Geo::Landmark),
      stub_model(Geo::Landmark)
    ])
  end

  it "renders a list of geo_landmarks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
