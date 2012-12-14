class CreateEventOccasions < ActiveRecord::Migration
  def change
    create_table :event_occasions do |t|
      t.datetime :start
      t.datetime :end
      t.references :event

      t.timestamps
    end
    add_index :event_occasions, :event_id
  end
end
