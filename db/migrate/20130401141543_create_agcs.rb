class CreateAgcs < ActiveRecord::Migration
  def change
    create_table :agcs do |t|
      t.integer_array :agus
    end
    add_index :agcs, :agus, unique: true
  end
end
