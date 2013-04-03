class DropEventOccurences < ActiveRecord::Migration

  def up
    drop_table :event_occurrences
  end

end
