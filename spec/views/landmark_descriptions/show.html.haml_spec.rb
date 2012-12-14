require 'spec_helper'

describe "landmark_descriptions/show" do
  before(:each) do
    assign :landmark_description, LandmarkDescription.make!
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
