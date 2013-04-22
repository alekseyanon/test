class CreateVideoLinks < ActiveRecord::Migration
  def change
    create_table :video_links, id: false do |t|
      t.references :user
      t.references :movie_star, polymorphic: true
      t.string :video_id
      t.string :video_type

      t.timestamps
    end
    add_index :video_links, :user_id
    add_index :video_links, :movie_star_id
    add_index :video_links, [:movie_star_id, :user_id, :video_id], unique: true
  end
end
