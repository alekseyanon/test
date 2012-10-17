class CreateGeoLandmarks < ActiveRecord::Migration
  def change
    create_table :geo_landmarks do |t|
      t.string :name
      t.references :node

      t.string :type
      t.timestamps
    end
    add_index :geo_landmarks, :node_id
  end
end
