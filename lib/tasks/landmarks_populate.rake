def browse_category(name, content)
  create_landmarks name, content['osm']
  content['sub'].each{ |next_name, sub| browse_category next_name, sub } if content['sub']
end

def create_landmarks(category_name, osm_tag)
  return 0 if osm_tag.blank?
  print "#{osm_tag} -> #{category_name} : "
  i = 0
  category = Category.where(name: category_name).first
  osm_tag['.'] = "'='"
  Osm::Node.where("tags->'#{osm_tag}'").each do |n|
    landmark = Landmark.new
    landmark.osm = n
    landmark.save
    ld = LandmarkDescription.new
    ld.describable =  landmark
    ld.title = n.tags['name'] || "NoName"
    ld.tag_list = category.self_and_ancestors.map(&:name_ru)
    ld.save
    i += 1
  end
  puts i
  @total += i
end

namespace :landmarks do
  desc "creating landmarks from osm nodes by categories"
  task populate: :environment do
    categories_file_name = File.join(Rails.root, 'db', 'seeds', 'categories.yml')
    categories = YAML.load File.open(categories_file_name).read
    @total = 0
    load "#{Rails.root}/spec/support/blueprints.rb"
    categories.each{ |name, content| browse_category name, content }
    puts "Total of #@total landmarks created."
  end
end
