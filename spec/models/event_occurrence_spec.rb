require 'spec_helper'

describe EventOccurrence do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :start }
  it { should belong_to :event }
  describe '.for_week' do
    it 'must return EventOccurences for specifed week'
  end
end
