shared_examples_for "an abstract description" do
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should belong_to :user }
end
