shared_examples_for 'an abstract description' do
  it { should be_valid }
  it { should validate_presence_of :title }
  it { should belong_to :user }
  it { should belong_to :describable }
end

shared_examples_for 'text search against title and body' do
  def search(args) described_class.search args end
  it 'performs full text search against title and body' do
    #TODO add fuzzy / dictionary-based search
    search('Fishing').should =~ [d[0], d[2], d[3]]
    search('fish').should =~ [d[1], d[4]]
  end
end

shared_examples_for 'text search against title and body and tags' do
  def search(args) described_class.search args end
  it 'performs full text search against title, body and tags' do
    search('nature').should =~ [d[1], d[2], d[4]]
    search('sports_goods').should =~ [d[2], d[3]]
    search('lake').should == [d[1]]
  end
end

shared_examples_for 'combined search' do
  it 'performs full text search for geo units around coordinates provided' do
    d[0].describable.osm = osm
    d[0].describable.save
    described_class.search(text: "fishing", geom: osm.geom, r: 1).should == [d[0]]
    described_class.search(text: "fishing", geom: osm.geom, r: 100).should == [d[0], d[2], d[3]]
  end
end

shared_examples_for 'combined faceted search' do
  it 'performs faceted combined text + geo search' do
    d[0].describable.osm = osm
    d[0].describable.save
    described_class.search(text: "fishing", geom: osm.geom, r: 1, facets:[:lodging, :activities]).should == [d[0]]
    described_class.search(text: "fishing", geom: osm.geom, r: 100, facets:[:activities]).should =~ [d[0], d[2]]
    described_class.search(text: "fishing", geom: osm.geom, r: 100, facets:[:lodging]).should =~ [d[0], d[3]]
  end
end
