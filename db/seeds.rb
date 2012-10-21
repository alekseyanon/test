# fun coding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_categories(parent, sub)
  sub.each do |name, value|
    is_leaf =  value.kind_of? String
    c = Category.create! :name => name, :description => (is_leaf ? value : value['desc'])
    c.move_to_child_of parent
    create_categories c, value['sub'] unless is_leaf
  end
end

categories_file_name = File.join Rails.root, 'config', 'landmark_categories.yml'
categories = YAML.load File.open(categories_file_name).read
root_category = Category.create! :name => 'landmark_categories', :description => 'Категории географических объектов'
create_categories root_category, categories