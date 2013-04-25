require 'spec_helper'

describe Video do
  let(:unique_youtube_url) { 'http://www.youtube.com/watch?v=4wTLjEqj5Xk&a=GxdCwVVULXctT2lYDEPllDR0LRTutYfW' }
  let(:youtube_same_urls) { ['http://www.youtube.com/watch?v=DZGINaRUEkU',
                            'https://www.youtube.com/watch?v=DZGINaRUEkU',
                                    'www.youtube.com/watch?v=DZGINaRUEkU',
                                        'youtube.com/watch?v=DZGINaRUEkU&a=GxdCwVVULXctT2lYDEPllDR0LRTutYfW'] }
  let(:vimeo_same_urls) { ['https://vimeo.com/63645580',
                           'https://vimeo.com/63645580#comment',
                            'http://vimeo.com/63645580',
                                   'vimeo.com/63645580'] }
  let(:invalid_urls) { ['http://www.youtube.com/watch?v=4wTLj5Xk',
                        'http://www.youtub.com/watch?v=4wTLjEqj5Xk',
                        'http://vimeo.com/42',
                        'http://vmeo.com/63645580'] }

  describe '.find_or_create_by_url' do

    it 'finds or creates a new YouTube video from url' do
      -> do
        videos = youtube_same_urls.map { |url| Video.find_or_create_by_url url }
        videos.each do |v|
          v.class.should == YouTube
          v.vid.should == 'DZGINaRUEkU'
          v.should eq(videos.first)
        end
      end.should change(Video, :count).by(1)
    end

    it 'finds or creates a new Vimeo video from url' do
      -> do
        videos = vimeo_same_urls.map { |url| Video.find_or_create_by_url url }
        videos.each do |v|
          v.class.should == Vimeo
          v.vid.should == '63645580'
          v.should eq(videos.first)
        end
      end.should change(Video, :count).by(1)
    end

    it 'omits invalid urls' do
      -> do
        videos = invalid_urls.map { |url| Video.find_or_create_by_url url }
        require 'pp'; pp videos
        videos.compact!.should be_empty
      end.should_not change(Video, :count)
    end

    it 'creates videos of different kinds' do
      -> do
        ([unique_youtube_url] + youtube_same_urls + vimeo_same_urls + invalid_urls).each do |url|
          Video.find_or_create_by_url url
        end
      end.should change(Video, :count).by(3)
    end

  end
end
