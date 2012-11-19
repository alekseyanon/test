class Category < ActiveRecord::Base
  attr_accessible :name, :description, :name_ru
  validates :name_ru, :presence => true, :uniqueness => true
  acts_as_nested_set
end
