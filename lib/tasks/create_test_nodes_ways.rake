task create_test_nodes_ways: :environment do
  load "#{Rails.root}/spec/support/blueprints.rb"
  Osm::Poly.make! nodes: get_nodes_for_foursquare(-10,-10).map(&:id), tags: { name: 'Poly Test #1'}, id: 1
  Osm::Poly.make! nodes: get_nodes_for_foursquare(-30,-10).map(&:id), tags: { name: 'Poly Test #2'}, id: 2
  Osm::Poly.make! nodes: get_nodes_for_foursquare(-10,-30).map(&:id), tags: { name: 'Poly Test #3'}, id: 3
  Osm::Poly.make! nodes: get_nodes_for_foursquare(-30,-30).map(&:id), tags: { name: 'Poly Test #4'}, id: 4
  Osm::Poly.make! nodes: get_nodes_for_foursquare(-100,-100).map(&:id), tags: { name: 'Poly Test #5'}, id: 5
end

def get_nodes_for_foursquare start_x, start_y
  nodes = []
  id = start_y + start_x
  first = create_node(start_x, start_y)
  nodes << first
  nodes << create_node(start_x-10, start_y)
  nodes << create_node(start_x-10, start_y-10)
  nodes << create_node(start_x, start_y-10)
  nodes << first
  nodes
end

def create_node(x,y)
  attempts = 0
  begin
    id = Random.rand(9999999) + 1
    Osm::Node.make!(id: id, geom: Geo::factory.point(x, y))
  rescue ActiveRecord::RecordNotUnique
    attempts += 1
    retry unless attempts > 20
  end
end
