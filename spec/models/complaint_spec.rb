require 'spec_helper'

describe Complaint do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :content }
  it { should validate_presence_of :user }
  it { should validate_presence_of :complaintable }
  it { should belong_to :complaintable }
  it { should belong_to :user }
end
