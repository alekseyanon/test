def browse_category(name, content)
  create_landmarks name, content
  content['sub'].each{ |next_name, sub| browse_category next_name, sub } if content['sub']
end

def create_landmarks(category_name, content)
  return 0 if content['osm'].blank?
  print "#{content['osm']} -> #{category_name} : "
  i = 0
  category = Category.where(name: category_name).first
  tag_name, tag_value = content['osm'].split '.'
  tag_condition = "tags->'#{tag_name}' = '#{tag_value}'"
  Osm::Node.where(tag_condition).each do |node|
    create_landmark node, node.tags['name'], category
    i += 1
  end
  puts i
  if content['from_poly']
    puts "Import from poly"
    Osm::Poly.where(tag_condition).each do |poly|
      begin
        create_landmark Osm::Node.find(poly.nodes.first), poly.tags['title'], category
        i+=1
      rescue => e
        puts "#{e.class}: #{e.message}"
      end
    end
  end
  puts i
  @total += i
end

def create_landmark node, title, category
  landmark = Landmark.new
  landmark.osm = node
  landmark.save
  ld = LandmarkDescription.new
  ld.describable =  landmark
  ld.title = title || "NoName"
  ld.tag_list = category.self_and_ancestors.map(&:name_ru)
  ld.save
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