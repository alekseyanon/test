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

  it "should have pending_activation state after creation" do
    user.state.should == "pending_activation"
    user.should_not be_active
  end
end

describe User, "registration" do
  subject { described_class.make! }
  let (:user) { subject}

  it {user.register.should be_true}

  context do
    before { user.register }

    it { user.pending_activation?.should be_true }
  end

  it '#register create activated user' do
    user.register(:activate => true).should be_true
    user.should be_active
  end

  it 'change state to active' do
    lambda {
      user.activate!
    }.should change(user, :state).from('pending_activation').to('active')
  end

  it "check state" do
    user.activate!
    user.should be_active
  end

  it "check name" do
    user.to_s.should be == user.name
  end

  
end