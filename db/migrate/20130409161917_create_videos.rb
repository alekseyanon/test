class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos, id: false do |t|
      t.string :vid, options: 'PRIMARY KEY'
      t.string :type

      t.timestamps
    end
    add_index :videos, :vid, unique: true
  end
end
