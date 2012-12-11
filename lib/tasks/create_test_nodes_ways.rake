task create_test_nodes_ways: :environment do
  load "#{Rails.root}/spec/support/blueprints.rb"
  Osm::Poly.make! nodes: get_nodes_for_foursquare(10,10).map(&:id), tags: { name: 'Poly Test #1'}
  Osm::Poly.make! nodes: get_nodes_for_foursquare(30,10).map(&:id), tags: { name: 'Poly Test #2'}
  Osm::Poly.make! nodes: get_nodes_for_foursquare(10,30).map(&:id), tags: { name: 'Poly Test #3'}
  Osm::Poly.make! nodes: get_nodes_for_foursquare(30,30).map(&:id), tags: { name: 'Poly Test #4'}
  Osm::Poly.make! nodes: get_nodes_for_foursquare(100,100).map(&:id), tags: { name: 'Poly Test #5'}
end

def get_nodes_for_foursquare start_x, start_y
  nodes = []
  first = Osm::Node.make!( geom: Geo::factory.point(start_x, start_y))
  nodes << first
  nodes << Osm::Node.make!( geom: Geo::factory.point(start_x+10, start_y))
  nodes << Osm::Node.make!( geom: Geo::factory.point(start_x+10, start_y+10))
  nodes << Osm::Node.make!( geom: Geo::factory.point(start_x, start_y+10))
  nodes << first
  nodes
end
