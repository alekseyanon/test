class CreateEventOccurrences < ActiveRecord::Migration
  def change
    create_table :event_occurrences do |t|
      t.datetime :start
      t.datetime :end
      t.references :event

      t.timestamps
    end
    add_index :event_occurrences, :event_id
  end
end
