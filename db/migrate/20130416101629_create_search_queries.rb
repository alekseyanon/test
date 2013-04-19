class CreateSearchQueries < ActiveRecord::Migration
  def change
    create_table :search_queries do |t|
      t.string :str, null: false
      t.integer :counter, default: 0, null: false
      t.boolean :blacklisted, default: false, null: false

      t.timestamps
    end

    add_index :search_queries, :str, unique: true
    add_index :search_queries, :counter
  end
end
