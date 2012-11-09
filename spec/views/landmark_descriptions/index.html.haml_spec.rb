require 'spec_helper'

describe "landmark_descriptions/index" do
  before(:each) do
    assign(:landmark_descriptions, [
      stub_model(LandmarkDescription),
      stub_model(LandmarkDescription)
    ])
  end

  it "renders a list of landmark_descriptions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
