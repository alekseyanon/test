require 'spec_helper'

describe VideoLink do

  let(:user_a) { User.make! }
  let(:user_b) { User.make! }
  let(:event_a) { Event.make! }
  let(:event_b) { Event.make! }
  let(:geo_object_a) { GeoObject.make! }
  let(:geo_object_b) { GeoObject.make! }
  let(:url_a) { 'http://www.youtube.com/watch?v=DZGINaRUEkU' }
  let(:url_b) { 'https://vimeo.com/63645580' }
  let(:url_c) { 'http://www.youtube.com/watch?v=4wTLjEqj5Xk' }

  describe '.find_or_create_by_content' do
    #creates video links from urls for users and content
    subject do
      -> do
        [[user_a, event_a, url_a],
         [user_b, event_a, url_a],
         [user_b, event_a, url_a], #same combination
         [user_a, geo_object_a, url_b],
         [user_b, event_b, url_a],
         [user_b, geo_object_b, url_c]].each { |(user, event, url)| VideoLink.find_or_create_by_content user, event, url }

        video_a, video_b, video_c = [url_a, url_b, url_c].map { |u| Video.find_or_create_by_url u }
        video_a.events.should =~ [event_a, event_b]
        video_b.events.should == []
        video_c.events.should == []
        video_b.geo_objects.should == [geo_object_a]
        video_c.geo_objects.should == [geo_object_b]
        video_a.users.should =~ [user_a, user_b]
        video_b.users.should == [user_a]
        video_c.users.should == [user_b]
        event_a.you_tubes.should == [video_a]
        event_b.you_tubes.should == [video_a]
        geo_object_a.you_tubes.should == []
        geo_object_a.vimeos.should == [video_b]
        user_a.you_tubes.should == [video_a]
        user_b.you_tubes.should =~ [video_a, video_c]
      end
    end

    it { should change(Video, :count).by(3) }
    it { should change(VideoLink, :count).by(5) }

  end
end
