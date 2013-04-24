require 'spec_helper'

describe User do
  subject { described_class.make! }
  let (:user) { subject}

  it { should be_valid }
  it { should have_many(:authentications) }

  it 'should not allow to save user without any role' do
    pending 'roles are not implemented'
    user.roles = []
    user.should_not be_valid
  end

	it 'should not allow incorrect emails' do
    user.email = 'foo bar'
    user.should_not be_valid
  end

  it {user.traveler?.should be_true}


  context 'find_or_create without users' do
    subject do
      oauth = get_credentials.merge('provider' => 'twitter',
                                    'uid' => Time.now.to_i.to_s,
                                    'info' => {'email' => "test#{Time.now.to_i}test@test.test"})
      -> do
        User.find_or_create(nil, oauth)
      end
    end
    it {should change(User, :count).by(1)}
    it {should change(Authentication, :count).by(1)}
  end

  context 'find_or_create with user' do
    subject do
      u = User.make!
      oauth = get_credentials.merge('provider' => 'facebook',
                                    'uid' => Time.now.to_i.to_s,
                                    'info' => {'email' => u.email})
      -> do
        User.find_or_create(nil, oauth)
      end
    end
    it {should_not change(User, :count)}
    it {should change(Authentication, :count).by(1)}
  end

  context 'find_or_create with user and authentication' do
    subject do
      a = Authentication.make!
      oauth = get_credentials.merge('provider' => a.provider,
                                            'uid' => a.uid,
                                            'info' => {'email' => a.user.email})
      -> do
        User.find_or_create(a, oauth)
      end
    end
    it {should_not change(User, :count)}
    it {should_not change(Authentication, :count)}
  end
end
