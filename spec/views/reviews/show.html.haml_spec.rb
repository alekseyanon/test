require 'spec_helper'

describe "reviews/show" do
  before(:each) do
    @review = assign(:review, stub_model(Review,
      :title => "Title",
      :body => "MyText",
      :user => nil,
      :reviewable => nil,
      :state => "State"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/State/)
  end
end
