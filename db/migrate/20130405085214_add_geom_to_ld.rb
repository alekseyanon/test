class AddGeomToLd < ActiveRecord::Migration
  def change
    add_column :abstract_descriptions, :pnt, 'geometry(Point,4326)'
    add_column :abstract_descriptions, :x, :real
    add_column :abstract_descriptions, :y, :real
  end
end
