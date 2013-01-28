require 'spec_helper'

describe "profiles/index" do
  before(:each) do
    assign(:profiles, [
      stub_model(Profile,
        :name => "Name",
        :avatar => "Avatar",
        :user => nil
      ),
      stub_model(Profile,
        :name => "Name",
        :avatar => "Avatar",
        :user => nil
      )
    ])
  end

  it "renders a list of profiles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Avatar".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
