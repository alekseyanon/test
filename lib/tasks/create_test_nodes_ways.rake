task create_test_nodes_ways: :environment do
  load "#{Rails.root}/spec/support/blueprints.rb"
  [[-10,-10], [-30, -10], [-10,-30], [-30,-30], [-100,-100]].each_with_index do |x,y,i|
    Osm::Poly.make! nodes: get_nodes_for_foursquare(x,y).map(&:id), tags: { name: "Poly Test #{i+1}"}, id: i+1
  end
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
