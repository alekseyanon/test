require 'spec_helper'

describe EventOccasion do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :start }
  it { should belong_to :event }
end
