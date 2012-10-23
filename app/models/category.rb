class Category < ActiveRecord::Base
  attr_accessible :name, :description
  validates :name, :description, :presence => true, :uniqueness => true
  acts_as_nested_set
end
