class AddOauthTokenFieldsToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :oauth_token, :string
    add_column :authentications, :oauth_token_secret, :string
  end
end
