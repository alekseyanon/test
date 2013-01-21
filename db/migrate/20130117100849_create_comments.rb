class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.string :state
      t.string :commentable_type
      t.references :commentable
      t.references :user

      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end
    add_index :comments, :commentable_id
    add_index :comments, :user_id
  end
end
