class AddFieldsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :name, :string
    add_column :users, :external_picture_url, :string
  end
end
