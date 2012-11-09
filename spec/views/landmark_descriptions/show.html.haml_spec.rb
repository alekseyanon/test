require 'spec_helper'

describe "landmark_descriptions/show" do
  before(:each) do
    @landmark_description = assign(:landmark_description, stub_model(LandmarkDescription))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
