require 'spec_helper'

describe "geo/landmarks/edit" do
  before(:each) do
    @landmark = assign(:geo_landmark, stub_model(Geo::Landmark))
  end

  it "renders the edit landmark form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => geo_landmarks_path(@landmark), :method => "post" do
    end
  end
end
