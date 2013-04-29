require "spec_helper"

RSpec::Matchers.define :allow do |*args|
  match do |permission|
    permission.allow?(*args).should be_true
  end
end

describe Permission do
  describe "as guest" do
    subject { Permission.new(nil) }
    
    it "allows events" do
      should allow(:events, :index)
      should allow(:events, :show)
      should_not allow(:events, :new)
      should_not allow(:events, :create)
      should_not allow(:events, :edit)
      should_not allow(:events, :update)
      should_not allow(:events, :destroy)
    end

  end
  
  # TODO not implemented
  # describe "as admin" do
  #   subject { Permission.new(build(:user, admin: true)) }
    
  #   it "allows anything" do
  #     should allow(:anything, :here)
  #     should allow_param(:anything, :here)
  #   end
  # end
  
  describe "as member" do
    let(:user) { User.make! }
    let(:user_event) { Event.make user: user }
    let(:other_event) { Event.make }
    subject { Permission.new(user) }
    
    it "allows events" do
      should allow(:events, :index)
      should allow(:events, :show)
      should allow(:events, :new)
      should allow(:events, :create)
      should_not allow(:events, :edit)
      should_not allow(:events, :update)
      should_not allow(:events, :edit, other_event)
      should_not allow(:events, :update, other_event)
      should allow(:events, :edit, user_event)
      should allow(:events, :update, user_event)
      should_not allow(:events, :destroy)
    end
  
  end
end
