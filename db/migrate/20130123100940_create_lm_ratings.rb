class CreateLmRatings < ActiveRecord::Migration
  def change
    create_table :lm_ratings do |t|
      t.references :user
      t.references :landmark_description
      t.integer :value

      t.timestamps
    end
    add_index :lm_ratings, :user_id
    add_index :lm_ratings, :landmark_description_id
  end
end
