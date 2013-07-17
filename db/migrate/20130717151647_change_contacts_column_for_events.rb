class ChangeContactsColumnForEvents < ActiveRecord::Migration
  def up
    remove_column :events, :contacts
    add_column    :events, :contacts, :string_array
  end

  def down
    remove_column :events, :contacts
    add_column    :events, :contacts, :hstore
  end
end
