class CreateRuntips < ActiveRecord::Migration
  def change
    create_table :runtips do |t|
      t.text :body
      t.references :user
      t.references :geo_object

      t.timestamps
    end
    add_index :runtips, :user_id
    add_index :runtips, :geo_object_id
  end
end
