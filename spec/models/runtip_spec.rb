require 'spec_helper'

describe Runtip do
	subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :body }
  it { should belong_to :user }
  it { should belong_to :geo_object }
end
