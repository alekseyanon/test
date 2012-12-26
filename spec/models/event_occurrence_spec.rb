require 'spec_helper'

describe EventOccurrence do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :start }
  it { should belong_to :event }

  let(:event_occurrences) do 
    [ 
      EventOccurrence.make!, 
      EventOccurrence.make!(start: Chronic.parse('next week')), 
      EventOccurrence.make!
    ]
  end

  describe '.for_week' do
    it 'must return EventOccurences for specifed week' do
      event_occurrences
      EventOccurrence.for_week.count.should == 2
    end
  end
end
