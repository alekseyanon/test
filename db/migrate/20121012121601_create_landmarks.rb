class CreateLandmarks < ActiveRecord::Migration
  def change
    create_table :landmarks do |t|
      t.string :name
      t.references :node

      t.string :type
      t.timestamps
    end
    add_index :landmarks, :node_id
  end
end
