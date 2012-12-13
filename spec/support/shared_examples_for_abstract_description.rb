shared_examples_for "an abstract description" do
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should belong_to :user }
  it { should belong_to :describable }
end

shared_examples_for "text search" do
  def search(args) described_class.search args end
  it 'performs full text search against title and body' do
    #TODO add fuzzy / dictionary-based search
    search('Fishing').should =~ [d[0], d[2], d[3]]
    search('fish').should =~ [d[1], d[4]]
  end
  it 'performs full text search against title, body and tags' do
    search('nature').should =~ [d[1], d[2], d[4]]
    search('sports_goods').should =~ [d[2], d[3]]
    search('lake').should == [d[1]]
  end
end
