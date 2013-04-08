class MakeAgcIndexUnique < ActiveRecord::Migration
  def change
    remove_index :agcs, :relations
    add_index :agcs, :relations, unique: true
  end
end
