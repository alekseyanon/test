#encoding: utf-8

task import: :environment do
  raise "Wrong number of arguments" if ARGV.count != 2
  file_for_import = ARGV.last

  load "#{Rails.root}/spec/support/blueprints.rb"
  objects = JSON.parse File.read(file_for_import), symbolize_names: true

  user = User.make!
  next_id = Osm::Node.order("id DESC").pluck(:id).first
  next_id = 0 if next_id.nil?
  objects.each do |obj|
    next_id += 1
    # TODO много категорий
    category = Category.find_by_name_ru obj[:categories].first
    latlon = obj[:latlon].split ' '
    node = Osm::Node.make! geom: "POINT(#{latlon[1]} #{latlon[0]})", id: next_id
    landmark = Landmark.make! osm: node
    ld = LandmarkDescription.make! describable: landmark,
      title: obj[:title],
      body: obj[:address],
      user: user,
      tag_list: category.name
  end

end
