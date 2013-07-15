require 'spec_helper'

describe Vote do
  subject { described_class.make! }

  it { should be_valid }
  it { should belong_to(:voteable) }
  it { should belong_to(:voter) }
  it { should validate_uniqueness_of(:voteable_id).scoped_to([:voteable_type, :voter_type, :voter_id, :voteable_tag]) }
end
