require 'spec_helper'

describe "comments/new" do
  before(:each) do
    assign(:comment, stub_model(Comment,
      :body => "MyText",
      :state => "MyString",
      :commentable => nil,
      :user => nil
    ).as_new_record)
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => comments_path, :method => "post" do
      assert_select "textarea#comment_body", :name => "comment[body]"
      assert_select "input#comment_state", :name => "comment[state]"
      assert_select "input#comment_commentable", :name => "comment[commentable]"
      assert_select "input#comment_user", :name => "comment[user]"
    end
  end
end
