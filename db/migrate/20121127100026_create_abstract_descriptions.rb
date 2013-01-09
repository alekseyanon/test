class CreateAbstractDescriptions < ActiveRecord::Migration
  def change
    create_table :abstract_descriptions do |t|
      t.string :title
      t.text :body
      t.string :see_address
      t.references :user
      t.references :describable
      t.string :describable_type

      t.boolean :published
      t.datetime :published_at

      t.timestamps

      t.string :type
    end
  end
end
