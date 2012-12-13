desc "creates areas from ways"
task populate_areas: :environment do
  # TODO not load all at once
  Osm::Poly.where('geom is not null').each do |poly|
    a = Area.new
    a.osm = poly
    a.save!
  end
end
