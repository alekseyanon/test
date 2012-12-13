shared_examples_for "an abstract description" do
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should belong_to :user }
  it { should belong_to :describable }
end

shared_examples_for "text search" do
  it 'performs full text search against title and body' do
    #TODO add fuzzy / dictionary-based search
    described_class.search('Fishing').should =~ [d[0], d[2], d[3]]
    described_class.search('fish').should =~ [d[1], d[4]]
  end
  it 'performs full text search against title, body and tags' do
    described_class.search('net').should =~ [d[2], d[3]]
    described_class.search('gear').should =~ [d[1], d[3]]
    described_class.search('line').should =~ [d[1], d[2], d[3], d[4]]
    described_class.search('tools').should =~ [d[1], d[2], d[3], d[4]]
  end
end
