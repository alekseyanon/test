require 'spec_helper'

describe Review do
  
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should validate_presence_of :reviewable }
  it { should belong_to :user }
  it { should belong_to :reviewable }

end
