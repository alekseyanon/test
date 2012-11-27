class CreateAbstractDescriptions < ActiveRecord::Migration
  def change
    create_table :abstract_descriptions do |t|
      t.string :title
      t.text :body
      t.references :user
      t.references :landmark #TODO change reference to GeoUnit once it's here

      t.boolean :published
      t.datetime :published_at

      t.timestamps

      t.string :type
    end
  end
end
