require 'spec_helper'

describe "profiles/new" do
  before(:each) do
    assign(:profile, stub_model(Profile,
      :name => "MyString",
      :avatar => "MyString",
      :user => nil
    ).as_new_record)
  end

  it "renders new profile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => profiles_path, :method => "post" do
      assert_select "input#profile_name", :name => "profile[name]"
      assert_select "input#profile_avatar", :name => "profile[avatar]"
      assert_select "input#profile_user", :name => "profile[user]"
    end
  end
end
