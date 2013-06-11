class AddRatingsFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :commentator,  :float, default: 0
    add_column :users, :photographer, :float, default: 0
    add_column :users, :expert,       :float, default: 0
    add_column :users, :discoverer,   :float, default: 0
    add_column :users, :blogger,      :float, default: 0
  end
end
