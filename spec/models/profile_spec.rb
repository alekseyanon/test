require 'spec_helper'

describe Profile do
  subject { described_class.make! }
  it { should be_valid }
  it { should belong_to :user }
end
