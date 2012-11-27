class CreateAbstractDescriptions < ActiveRecord::Migration
  def change
    create_table :abstract_descriptions do |t|
      t.string :title
      t.text :body
      t.references :user
      t.references :describable

      t.boolean :published
      t.datetime :published_at

      t.timestamps

      t.string :type
    end
  end
end
