require 'spec_helper'

describe "images/show" do
  before(:each) do
    @image = assign(:image, stub_model(Image,
      :image => "Image",
      :state => "State",
      :imageable => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Image/)
    rendered.should match(/State/)
    rendered.should match(//)
  end
end
