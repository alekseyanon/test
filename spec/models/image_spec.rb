require 'spec_helper'

describe Image do
  subject { described_class.make! }
  it { should be_valid }
  it { should belong_to :imageable }
end
