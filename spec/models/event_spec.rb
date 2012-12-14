require 'spec_helper'

describe Event do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should belong_to :user }
  it { should belong_to :landmark }

  let(:event_notvalid){ Event.make! duration: 7}
  let(:event_valid){ Event.make! duration: 4}

  it "scheldule must be less than repeat period" do
    event_valid.should be_valid
    event_notvalid.should_not be_valid
  end
  it "после создания должен генерироваться первый оккажион"

  describe '.generate_occagions' do
    let(:event){Event.make!}
    it "должен генерировать окажены на n месяцев вперед согласну правилу scheldule" do
      event.generate_occagions 3
      event.occasions.count.should == 12
    end
  end
end
