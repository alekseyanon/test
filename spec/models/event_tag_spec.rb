# encoding: utf-8
require 'spec_helper'

describe EventTag do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should validate_uniqueness_of :title }
end
