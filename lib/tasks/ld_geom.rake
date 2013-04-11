namespace :ld do
  desc "add geom coordinates to Landmark descriptions"
  task geom: :environment do
    LandmarkDescription.find_each do |ld|
      geom = ld.describable.osm.geom
      ld.update_attributes(geom: geom)
      puts "===========> #{ld.id}"
    end
  end
end
