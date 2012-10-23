require 'spec_helper'

describe Category do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :name }
  it { should validate_presence_of :description }
  it { should validate_uniqueness_of :name}
  it { should validate_uniqueness_of :description}
  it 'acts as nested set' do
    child = described_class.make!
    child.move_to_child_of subject
    child.parent.should == subject
    subject.children.should == [child]
  end
end
