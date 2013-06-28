def browse_category(name, content)
  create_objects name, content
  content['sub'].each{ |next_name, sub| browse_category next_name, sub } if content['sub']
end

def create_objects(category_name, content)
  return 0 if content['osm'].blank?
  print "#{content['osm']} -> #{category_name} : "
  category = Category.where(name: category_name).first
  if (osm_tags = content['osm']).is_a? Array
    osm_tags.each { |tag| create_osm content['from_poly'], category, tag }
  else
    create_osm content['from_poly'], category, osm_tags 
  end
end

def create_osm from_poly, category, tag
  i = 0
  tag_name, tag_value = tag.split '.'
  tag_condition = "tags->'#{tag_name}' = '#{tag_value}'"
  Osm::Node.where(tag_condition).each do |node|
    create_object node, node.tags['name'], category
    i += 1
  end
  puts i
  if from_poly
    puts "===> Import from poly <==="
    Osm::Poly.where(tag_condition).each do |poly|
      create_object Osm::Node.find(poly.nodes.first), poly.tags['title'], category
      i+=1
    end
  end
  puts "*** All in Category #{i} ***"
  @total += i
end

def create_object node, title, category
  o = GeoObject.new title: (title || "NoName"),
                    tag_list: category.self_and_ancestors.map(&:name),
                    geom: node.geom
  o.user = @user
  o.save!
rescue => ex
  puts "!!! Can't create landmark: node.id #{node.id}; title '#{title}' !!!"
end


namespace :objects do
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
