class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string     :title
      t.text       :body
      t.text       :scheldule
      t.integer    :duration
      t.references :user
      t.references :landmark

      t.timestamps
    end
    add_index :events, :user_id
    add_index :events, :landmark_id
  end
end
