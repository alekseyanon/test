class AddContactsFieldsToEvent < ActiveRecord::Migration
  def change
    add_column    :events, :address,    :string
    add_column    :events, :contacts,   :hstore
    add_column    :events, :start_time, :time
  end
end

