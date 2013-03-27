class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string     :title
      t.text       :body
      t.text       :schedule
      t.datetime   :start_date
      t.datetime   :end_date
      t.datetime   :archive_at
      t.string     :repeat_rule
      t.string     :state
      t.string     :key
      t.datetime   :published_at
      t.references :user

      t.timestamps
    end
    add_index :events, :user_id
  end
end
