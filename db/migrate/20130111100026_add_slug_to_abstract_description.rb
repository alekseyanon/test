class AddSlugToAbstractDescription < ActiveRecord::Migration
  def change
  	add_column :abstract_descriptions, :slug, :string
  	add_index :abstract_descriptions, :slug
  end
end
