require 'spec_helper'

describe User do
  subject { described_class.make! }
  let (:user) { subject}

  it { should be_valid }
  it { should have_many(:authentications) }
  it { should have_many(:images) }
  it { should have_many(:complaints) }

  it 'should not allow to save user without any role' do
    pending 'roles are not implemented'
    user.roles = []
    user.should_not be_valid
  end

	it 'should not allow incorrect emails' do
    user.email = 'foo bar'
    user.should_not be_valid
  end

  it {user.traveler?.should be_false}
  it {user.admin?.should be_true}

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

  let!(:blogger){User.make! blogger: 3}
  let!(:expert){User.make! expert: 3}

  it 'get users list sorted by rating' do
    User.sorted_list_with_page('blogger DESC').first.should == blogger
    User.sorted_list_with_page('expert DESC').first.should == expert
  end

  context 'ratings' do
    it 'should calculate correct overall rating' do
      user.commentator  = 1.2
      user.photographer = 1.5
      user.expert       = 2.1
      user.discoverer   = 7.8
      user.blogger      = 0.2

      user.rating.should == 12.8
    end

    it 'should update user rating' do
      GeoObject.make! user: user
      lambda { user.update_rating_all }.should change(user, :rating).from(0.0).to(1.4)
    end

    it 'should get recommenders count' do
      another_user = User.make!
      another_user.vote_for(Event.make! user: user)
      another_user.vote_for(Event.make! user: user)
      user.recommenders(:events).should eql(2)
    end

    it 'should get recommenders count within 1 hours' do
      another_user = User.make!
      another_user.vote_for(Event.make! user: user)
      vote = another_user.vote_for(Event.make! user: user)
      vote.created_at = Time.now - 2.hours
      vote.save!

      user.recommenders_last_hour(:events).should eql(1)
    end

  end

end
