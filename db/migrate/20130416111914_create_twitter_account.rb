class CreateTwitterAccount < ActiveRecord::Migration
  def up
    create_table 'twitter_accounts' do |t|
      t.integer :user_id
      t.boolean  'active', default: false
      t.text     'stream_url'
      t.string   'oauth_token'
      t.string   'oauth_token_secret'
      t.string   'oauth_token_verifier'
      t.text     'oauth_authorize_url'
    end
  end

  def down
    drop_table 'twitter_accounts'
  end
end
