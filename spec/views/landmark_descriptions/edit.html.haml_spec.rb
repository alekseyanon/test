require 'spec_helper'

describe "landmark_descriptions/edit" do
  before(:each) do
    @landmark_description = assign(:landmark_description, stub_model(LandmarkDescription))
  end

  it "renders the edit landmark_description form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => landmark_descriptions_path(@landmark_description), :method => "post" do
    end
  end
end
