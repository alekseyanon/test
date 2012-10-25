require 'spec_helper'

describe Geo::Landmark do
  subject { described_class.make }
  it { should be_valid }
  it { should validate_presence_of :name }

  it { should belong_to :node }

  describe '.by_tags_count' do
    let!('landmark2'){described_class.make!}
    let!('landmark3'){described_class.make!}
    let!('landmark4'){described_class.make!}
    let!('landmark5'){described_class.make!}

    it 'finds tagged landmarks' do
      subject.tag_list   = 'a, b, c'
      subject.save
      landmark2.tag_list = 'a, b'
      landmark2.save
      landmark3.tag_list = 'a'
      landmark3.save
      Geo::Landmark.by_tags_count(%w(a)).should  =~ [subject, landmark2, landmark3]
      Geo::Landmark.by_tags_count(%w(b c)).should  =~ [subject, landmark2]
    end

    it 'sorts tagged landmarks by tag count' do
      subject.tag_list   = 'aa, bb, cc, dd, ee'
      subject.save
      landmark2.tag_list = 'bb, cc, dd, ee'
      landmark2.save
      landmark3.tag_list = 'cc, dd, ee'
      landmark3.save
      landmark4.tag_list = 'aa, ee'
      landmark4.save
      landmark5.tag_list = 'ff, gg'
      landmark5.save

      by_4_tags = Geo::Landmark.by_tags_count(%w(aa bb dd ee))
      by_4_tags.should =~ [subject, landmark2, landmark3, landmark4]
      by_4_tags.first(2).should  == [subject, landmark2]

      by_3_tags = Geo::Landmark.by_tags_count(%w(ee ff gg))
      by_3_tags.should  =~ [subject, landmark2, landmark3, landmark4, landmark5]
      by_3_tags.first.should == landmark5
    end
  end
end