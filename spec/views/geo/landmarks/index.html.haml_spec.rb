require 'spec_helper'

describe "landmarks/index" do
  before(:each) do
    assign(:landmarks, [
      Landmark.make!,
      Landmark.make!
    ])
  end

  it "renders a list of landmarks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
