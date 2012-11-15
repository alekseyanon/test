class AddSubcribtionToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :news_subscribed, :boolean
  	add_column :users, :comments_subscribed, :boolean
  	add_column :users, :answer_subscribed, :boolean
  end
end
