class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image
      t.string :state
      t.string :imageable_type
      t.references :imageable

      t.timestamps
    end
    add_index :images, :imageable_id
  end
end
