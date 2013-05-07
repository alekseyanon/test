class CreateAgus < ActiveRecord::Migration
  def change
    create_table :agus do |t|
      t.string  :title, null: false
      t.boolean :place, null: false, default: false
      t.polygon :geom,  null: false, srid: Geo::SRID
      t.timestamps
    end
    # Индексы ко всему, т.к. обновляться будет очень редко
    # выборки и чтение часто
    add_index :agus, :title
    add_index :agus, :place
    add_index :agus, :geom
  end
end
