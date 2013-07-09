require 'spec_helper'
require 'cancan/matchers'

describe 'Abilities' do
  subject { ability }
  let(:ability) { Ability.new(user) }

  context 'when user has no role' do
    let(:user) { nil }
    it{ should be_able_to(:read, :all) }
  end

  context 'when user is an admin' do
    let(:user) { User.make! roles: [:admin] }
    it{ should be_able_to(:manage, :all) }
  end

  context 'when user is a traveler' do
    let(:user) { User.make! roles: [:traveler] }

    it{ should be_able_to(:read, :all) }
    it{ should be_able_to(:create, :all) }
    it{ should be_able_to(:update, GeoObject.make!) }

    classes = [Comment, Complaint, Event, Review]
    classes.each do |test_class|
      it "should be able to update and delete own #{test_class}" do
        object = test_class.make! user: user
        should be_able_to(:update, object)
        should be_able_to(:destroy, object)
      end

      it "should not be able to update or delete own #{test_class} after 15 minutes" do
        object = test_class.make! user: user, updated_at: Time.now - 16.minutes
        should_not be_able_to(:update, object)
        should_not be_able_to(:destroy, object)
      end

      it "should not be able to update or delete #{test_class} of other user" do
        object = test_class.make!
        should_not be_able_to(:update, object)
        should_not be_able_to(:destroy, object)
      end
    end

  end

end
