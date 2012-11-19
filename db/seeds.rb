# fun coding: UTF-8

def create_category(parent, category)
  c = Category.create! name_ru: category[:name]
  c.move_to_child_of parent
  category[:children].each do |sub_cat|
    create_category c, sub_cat
  end
end

categories_file_name = File.join(Rails.root, 'db', 'seeds', 'categories.yml')
categories = YAML.load File.open(categories_file_name).read
root_category = Category.create! name_ru: 'Категории географических объектов'

categories.each do |c|
  create_category root_category, c
end
