require 'spec_helper'

describe "landmark_descriptions/edit" do
  before(:each) do
    assign :landmark_description, LandmarkDescription.make!
    assign :categories, [Category.make!]
  end

  it "renders the edit landmark_description form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => landmark_descriptions_path(@landmark_description), :method => "post" do
    end
  end
end
