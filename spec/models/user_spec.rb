require 'spec_helper'

describe User do
  subject { described_class.make! }
  let (:user) { subject}
  
  it { should be_valid }
  # it { should validate_presence_of :name }
  # it { should validate_presence_of :description }
  it { should have_many(:authentications) }

  it "should not allow to save user without any role" do
    user.roles = []
    user.should_not be_valid
  end

	it "should not allow incorrect emails" do
    user.email = 'foo bar'
    user.should_not be_valid
  end

  it {user.traveler?.should be_true}
end
