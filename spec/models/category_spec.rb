require 'spec_helper'

describe Category do
  subject { described_class.make! }
  it { should be_valid }
  it { should validate_presence_of :name_ru }
  it 'acts as nested set' do
    child = described_class.make!
    child.move_to_child_of subject
    child.parent.should == subject
    subject.children.should == [child]
  end
end
