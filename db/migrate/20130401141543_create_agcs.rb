class CreateAgcs < ActiveRecord::Migration
  def change
    create_table :agcs do |t|
      t.integer_array :relations
    end
    add_index :agcs, :relations
  end
end
