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
    puts "===> Import from poly <==="
    Osm::Poly.where(tag_condition).each do |poly|
      create_landmark Osm::Node.find(poly.nodes.first), poly.tags['title'], category
      i+=1
    end
  end
  puts "*** All in Category #{i} ***"
  @total += i
end

def create_landmark node, title, category
  landmark = Landmark.create osm: node
  ld = LandmarkDescription.new describable: landmark,
                             title: (title || "NoName"),
                             tag_list: category.self_and_ancestors.map(&:name),
                             geom: node.geom
  ld.user = @user
  ld.save!
rescue => ex
  puts "!!! Can't create landmark: node.id #{node.id}; title '#{title}' !!!"
  #puts "#{ex.class} => #{ex.message}"
end


namespace :landmarks do
  desc "creating landmarks from osm nodes by categories"
  task populate: :environment do
    categories_file_name = File.join(Rails.root, 'db', 'seeds', 'categories.yml')
    categories = YAML.load File.open(categories_file_name).read
    load "#{Rails.root}/spec/support/blueprints.rb"
    @user = User.make!
    @total = 0
    categories.each{ |name, content| browse_category name, content }
    puts "Total of #@total landmarks created."
  end
end
