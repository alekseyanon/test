#encoding: utf-8

task import: :environment do

  load "#{Rails.root}/spec/support/blueprints.rb"
  objects = JSON.parse File.read('tmp/mxkr.json'), symbolize_names: true

  user = User.make!
  next_id = Osm::Node.order("id DESC").pluck(:id).first
  next_id = 0 if next_id.nil?
  objects.each do |obj|
    next_id += 1
    latlon = obj[:latlon].split ' '
    node = Osm::Node.make! geom: "POINT(#{latlon[1]} #{latlon[0]})", id: next_id
    landmark = Landmark.make! osm: node
    LandmarkDescription.make! describable: landmark, title: obj[:title], body: obj[:address], user: user
  end

end
