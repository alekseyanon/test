require 'spec_helper'

describe "landmarks/show" do
  before(:each) do
    @landmark = assign :landmark, Landmark.make!
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
