require 'spec_helper'

describe "images/edit" do
  before(:each) do
    @image = assign(:image, stub_model(Image,
      :image => "MyString",
      :state => "MyString",
      :imageable => nil
    ))
  end

  it "renders the edit image form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => images_path(@image), :method => "post" do
      assert_select "input#image_image", :name => "image[image]"
      assert_select "input#image_state", :name => "image[state]"
      assert_select "input#image_imageable", :name => "image[imageable]"
    end
  end
end
