require 'spec_helper'

describe "landmark_descriptions/index" do
  before(:each) do
    assign :landmark_descriptions, Kaminari.paginate_array( Array.new(2){ |i| LandmarkDescription.make!}).page(1)
  end

  it "renders a list of landmark_descriptions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
