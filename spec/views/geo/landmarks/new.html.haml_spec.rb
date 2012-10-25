require 'spec_helper'

describe "geo/landmarks/new" do
  before(:each) do
    assign(:geo_landmark, stub_model(Geo::Landmark).as_new_record)
  end

  it "renders new landmark form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => geo_landmarks_path, :method => "post" do
    end
  end
end
