class AdditionalFieldsToObjects < ActiveRecord::Migration
  def change
    add_column :geo_objects, :schedule,  :text
  end
end
