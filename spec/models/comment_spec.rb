require 'spec_helper'

describe Comment do
  subject { described_class.make! }
  it { should be_valid }  
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should validate_presence_of :commentable }
  it { should belong_to :commentable }
  it { should belong_to :user }
end
