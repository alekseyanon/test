require 'spec_helper'

describe "geo/landmarks/show" do
  before(:each) do
    @landmark = assign(:geo_landmark, stub_model(Geo::Landmark))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
