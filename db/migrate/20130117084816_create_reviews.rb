class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :body
      t.references :user
      t.references :reviewable
      t.string :reviewable_type
      t.string :state

      t.timestamps
    end
    add_index :reviews, :user_id
    add_index :reviews, :reviewable_id
  end
end
