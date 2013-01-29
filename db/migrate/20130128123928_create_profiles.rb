class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :avatar
      t.string :slug
    
      t.hstore :settings
      t.references :user

      t.timestamps
    end
    add_index :profiles, :user_id
    add_index :profiles, :slug
  end
end
