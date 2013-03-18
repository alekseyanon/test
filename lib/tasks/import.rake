#encoding: utf-8

task import: :environment do

  file_for_import = ARGV.last
  extension = File.extname(file_for_import)

  case extension
  when '.yml'
    objects = YAML.load_file(file_for_import)
  when '.json'
    objects = JSON.parse File.read(file_for_import), symbolize_names: true
  else
    raise "Need json or yaml file to process"
  end

  load "#{Rails.root}/spec/support/blueprints.rb"

  user = User.make!
  next_id = Osm::Node.order("id DESC").pluck(:id).first || 0
  objects.each do |obj|
    next_id += 1
    # TODO много категорий
    category = Category.find_by_name_ru obj[:categories].first
    if category.nil?
      puts "No category #{obj[:categories].first}"
      next
    end
    node = Osm::Node.make! geom: "POINT(#{obj[:lon]} #{obj[:lat]})", id: next_id
    landmark = Landmark.make! osm: node
    ld = LandmarkDescription.make! describable: landmark,
      title: obj[:title],
      body: obj[:address],
      user: user,
      tag_list: category.name
  end

end
