class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.references :user
      t.references :landmark

      t.boolean :published
      t.datetime :published_at

      t.timestamps

      t.string :type
    end
    add_index :articles, :user_id
  end
end
