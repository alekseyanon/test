require 'spec_helper'

describe "landmarks/edit" do
  before(:each) do
    @landmark = assign(:landmark, Landmark.make!)
  end

  it "renders the edit landmark form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => landmarks_path(@landmark), :method => "post" do
    end
  end
end
