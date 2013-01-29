class CreateLmRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :user
      t.references :landmark_description
      t.integer :value

      t.timestamps
    end
    add_index :ratings, :user_id
    add_index :ratings, :landmark_description_id
  end
end
