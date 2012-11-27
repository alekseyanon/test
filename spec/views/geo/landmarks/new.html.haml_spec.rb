require 'spec_helper'

describe "landmarks/new" do
  before(:each) do
    assign :landmark, Landmark.make!
  end

  it "renders new landmark form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => landmarks_path, :method => "post" do
    end
  end
end
