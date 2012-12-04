class AddFieldsToAbstractDescription < ActiveRecord::Migration
  def change
  	add_column :abstract_descriptions, :see_address, :string
  end
end
