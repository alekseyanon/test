class Category < ActiveRecord::Base
  attr_accessible :name, :description, :name_ru, :parent_id
  validates :name_ru, :presence => true #, :uniqueness => true TODO consider making names unique
  acts_as_nested_set

  def as_json options = nil
    json = super except: [:created_at, :description, :lft, :rgt, :updated_at]
    json[:children] = children.map{|c| c.id}
    json
  end

end
