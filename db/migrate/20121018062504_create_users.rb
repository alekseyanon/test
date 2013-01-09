class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :roles

      t.string :name
      t.string :external_picture_url
      t.string :state
      t.string :perishable_token
      t.string :avatar

      t.boolean :news_subscribed
      t.boolean :comments_subscribed
      t.boolean :answer_subscribed


      t.timestamps
    end
  end
end
