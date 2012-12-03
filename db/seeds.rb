# fun coding: UTF-8

def create_category(parent, category)
  name, content = category
  c = Category.create! name: name, name_ru:(content.is_a?(String) ? content : content['ru'])
  c.move_to_child_of parent
  content['sub'].each{ |sub| create_category c, sub } if content.is_a?(Hash) && content['sub']
end

categories_file_name = File.join(Rails.root, 'db', 'seeds', 'categories.yml')
categories = YAML.load File.open(categories_file_name).read
root_category = Category.create! name_ru: 'Категории географических объектов'

categories.each do |c|
  create_category root_category, c
end
