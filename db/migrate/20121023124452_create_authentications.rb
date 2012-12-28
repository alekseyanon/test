class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|

    	t.string :name
    	t.string :email
    	t.string :provider
    	t.string :uid
    	t.string :role
    	t.string :url
    	t.string :picture

      t.integer :user_id

      t.timestamps
    end
  end
end
