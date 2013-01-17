require 'spec_helper'

describe "reviews/edit" do
  before(:each) do
    @review = assign(:review, stub_model(Review,
      :title => "MyString",
      :body => "MyText",
      :user => nil,
      :reviewable => nil,
      :state => "MyString"
    ))
  end

  it "renders the edit review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path(@review), :method => "post" do
      assert_select "input#review_title", :name => "review[title]"
      assert_select "textarea#review_body", :name => "review[body]"
      assert_select "input#review_user", :name => "review[user]"
      assert_select "input#review_reviewable", :name => "review[reviewable]"
      assert_select "input#review_state", :name => "review[state]"
    end
  end
end
