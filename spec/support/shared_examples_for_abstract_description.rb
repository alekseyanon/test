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

def update_abstract_description(d, osm)
  if d.kind_of? GeoObject
    d.geom = osm.geom
    d.save
  end
end

shared_examples_for 'combined search' do
  it 'performs full text search for geo units around coordinates provided' do
    update_abstract_description(d[0], osm)
    described_class.search(text: "fishing", geom: osm.geom, r: 1).should == [d[0]]
    described_class.search(text: "fishing", geom: osm.geom, r: 100).should == [d[0], d[2], d[3]]
  end
end

shared_examples_for 'combined faceted search' do
  it 'performs faceted combined text + geo search' do
    update_abstract_description(d[0], osm)
    described_class.search(text: "fishing", geom: osm.geom, r: 1, facets:[:lodging, :activities]).should == [d[0]]
    described_class.search(text: "fishing", geom: osm.geom, r: 100, facets:[:activities]).should =~ [d[0], d[2]]
    described_class.search(text: "fishing", geom: osm.geom, r: 100, facets:[:lodging]).should =~ [d[0], d[3]]
  end
end

shared_examples_for "search within radius" do
  it 'returns objects within a specified radius of another object' do
    moscow_obj    = to_point [37.617778, 55.751667]
    spb_obj       = to_point [30.316667, 59.95]
    novgorod_obj  = to_point [44.0075, 56.326944]

    if described_class.columns_hash["geom"].geometric_type == RGeo::Feature::Polygon
      moscow_obj    = moscow_obj.buffer(0.01)
      spb_obj       = spb_obj.buffer(0.01)
      novgorod_obj  = novgorod_obj.buffer(0.01)
    end

    moscow   = described_class.make! geom: moscow_obj
    spb      = described_class.make! geom: spb_obj
    novgorod = described_class.make! geom: novgorod_obj

    # Примерное расстояние между городами:
    # Питер  - Москва       636,9км
    # Питер  - Н.Новгород   899,4км
    # Москва - Н.Новгород   403,2км

    described_class.within_radius(moscow.geom, 10*1000).should match_array [moscow]
    described_class.within_radius(moscow.geom, 500*1000).should match_array [moscow, novgorod]
    described_class.within_radius(moscow.geom, 650*1000).should match_array [moscow, novgorod, spb]
    described_class.within_radius(novgorod.geom, 650*1000).should match_array [moscow, novgorod]
  end

  it 'returns objects within a specified radius of polygon' do
    square = to_poly to_nodes [[0, 0], [0, 10], [10, 10], [10, 0], [0, 0]]
    p1 = to_point [1,1]      # inside square
    p2 = to_point [10.1, 0]  # outside square, in radius 12km
    p3 = to_point [11, 11]   # outside square, in radius 156km

    if described_class.columns_hash["geom"].geometric_type == RGeo::Feature::Polygon
      p1 = p1.buffer(0.01)
      p2 = p2.buffer(0.01)
      p3 = p3.buffer(0.01)
    end

    obj1 = described_class.make! geom: p1
    obj2 = described_class.make! geom: p2
    obj3 = described_class.make! geom: p3

    described_class.within_radius(square.geom, 100).should match_array [obj1]
    described_class.within_radius(square.geom, 12000).should match_array [obj1, obj2]
    described_class.within_radius(square.geom, 156000).should match_array [obj1, obj2, obj3]
  end
end
