class CreateEventTags < ActiveRecord::Migration
  def change
    create_table :event_tags do |t|
      t.string :title
      t.boolean :system

      t.timestamps
    end
    add_index :event_tags, :title, { unique: true }
  end
end
