require 'spec_helper'

describe Geo::Landmark do
  subject { described_class.make }
  it { should be_valid }
  it { should validate_presence_of :id }
  it { should validate_presence_of :name }

  it { should belong_to :node }
end