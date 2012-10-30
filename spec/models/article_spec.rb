require 'spec_helper'

describe Article do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
