class CreateEventTaggings < ActiveRecord::Migration
  def change
    create_table :event_taggings do |t|
      t.belongs_to :event_tag
      t.belongs_to :event

      t.timestamps
    end
    add_index :event_taggings, :event_tag_id
    add_index :event_taggings, :event_id
  end
end
