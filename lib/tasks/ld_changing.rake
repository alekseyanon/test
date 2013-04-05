namespace :ld do
  desc "changing landmarks from osm nodes by categories"
  task changing: :environment do
    LandmarkDescription.find_each do |ld|
      x = ld.describable.osm.geom.x
      y = ld.describable.osm.geom.y
      ld.update_attributes(x: x, y: y)
      puts "===========> #{ld.id}"
    end

  end
end
