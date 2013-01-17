require 'spec_helper'

describe "images/new" do
  before(:each) do
    assign(:image, stub_model(Image,
      :image => "MyString",
      :state => "MyString",
      :imageable => nil
    ).as_new_record)
  end

  it "renders new image form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => images_path, :method => "post" do
      assert_select "input#image_image", :name => "image[image]"
      assert_select "input#image_state", :name => "image[state]"
      assert_select "input#image_imageable", :name => "image[imageable]"
    end
  end
end
