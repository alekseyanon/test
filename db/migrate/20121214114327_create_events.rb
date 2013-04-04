class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string     :title
      t.text       :body
      t.text       :schedule
      t.datetime   :start_date
      t.integer    :duration
      t.string     :repeat_rule
      t.string     :image
      t.references :user
      t.references :landmark

      t.timestamps
    end
    add_index :events, :user_id
    add_index :events, :landmark_id
  end
end
