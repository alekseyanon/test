class AddContactsFieldsToEvent < ActiveRecord::Migration
  def up
    add_column    :events, :address,    :string
    add_column    :events, :contacts,   :hstore
    change_column :events, :start_date, :date
    change_column :events, :end_date,   :date
    add_column    :events, :start_time, :time
  end

  def down
    remove_column :events, :address
    remove_column :events, :contacts
    change_column :events, :start_date, :datetime
    change_column :events, :end_date,   :datetime
    remove_column :events, :start_time
  end
end
