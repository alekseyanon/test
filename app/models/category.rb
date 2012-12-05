class Category < ActiveRecord::Base
  attr_accessible :name, :description, :name_ru, :parent_id
  validates :name_ru, :presence => true #, :uniqueness => true TODO consider making names unique
  acts_as_nested_set
end
