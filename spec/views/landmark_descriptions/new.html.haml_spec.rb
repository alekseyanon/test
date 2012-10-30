require 'spec_helper'

describe "landmark_descriptions/new" do
  before(:each) do
    assign(:landmark_description, stub_model(LandmarkDescription).as_new_record)
  end

  it "renders new landmark_description form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => landmark_descriptions_path, :method => "post" do
    end
  end
end
