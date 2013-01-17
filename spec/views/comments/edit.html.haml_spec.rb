require 'spec_helper'

describe "comments/edit" do
  before(:each) do
    @comment = assign(:comment, stub_model(Comment,
      :body => "MyText",
      :state => "MyString",
      :commentable => nil,
      :user => nil
    ))
  end

  it "renders the edit comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => comments_path(@comment), :method => "post" do
      assert_select "textarea#comment_body", :name => "comment[body]"
      assert_select "input#comment_state", :name => "comment[state]"
      assert_select "input#comment_commentable", :name => "comment[commentable]"
      assert_select "input#comment_user", :name => "comment[user]"
    end
  end
end
