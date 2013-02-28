require 'spec_helper'

describe "landmark_descriptions/show" do
  before(:each) do
  	current_user
    assign :landmark_description, LandmarkDescription.make!
    assign :categories_tree, {}
    assign :x, 51
    assign :y, 56
  end

  it "renders attributes in <p>" do
    pending
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
