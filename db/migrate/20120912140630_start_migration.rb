# encoding: UTF-8

# ActiveRecord::Schema.define(:version => 20130401094341) do

class StartMigration < ActiveRecord::Migration
  def up

    execute "CREATE EXTENSION IF NOT EXISTS hstore"

    create_table "abstract_descriptions", :force => true do |t|
      t.string   "title"
      t.text     "body"
      t.string   "see_address"
      t.integer  "user_id"
      t.integer  "describable_id"
      t.string   "describable_type"
      t.boolean  "published"
      t.datetime "published_at"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
      t.string   "type"
      t.string   "slug"
    end

    add_index "abstract_descriptions", ["slug"], :name => "index_abstract_descriptions_on_slug"

    create_table "authentications", :force => true do |t|
      t.string   "name"
      t.string   "email"
      t.string   "provider"
      t.string   "uid"
      t.string   "role"
      t.string   "url"
      t.string   "picture"
      t.integer  "user_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

    create_table "categories", :force => true do |t|
      t.string   "name"
      t.string   "name_ru"
      t.string   "description"
      t.integer  "parent_id"
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "depth"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    create_table "comments", :force => true do |t|
      t.text     "body"
      t.string   "state"
      t.string   "commentable_type"
      t.integer  "commentable_id"
      t.integer  "user_id"
      t.integer  "parent_id"
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "depth"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
      t.string   "ancestry"
    end

    add_index "comments", ["ancestry"], :name => "index_comments_on_ancestry"
    add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
    add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

    create_table "complaints", :force => true do |t|
      t.text     "content"
      t.integer  "user_id"
      t.integer  "complaintable_id"
      t.string   "complaintable_type"
      t.datetime "created_at",         :null => false
      t.datetime "updated_at",         :null => false
    end

    add_index "complaints", ["user_id"], :name => "index_complaints_on_user_id"

    create_table "event_occurrences", :force => true do |t|
      t.datetime "start"
      t.datetime "end"
      t.integer  "event_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "event_occurrences", ["event_id"], :name => "index_event_occurrences_on_event_id"

    create_table "events", :force => true do |t|
      t.string   "title"
      t.text     "body"
      t.text     "schedule"
      t.datetime "start_date"
      t.integer  "duration"
      t.string   "repeat_rule"
      t.string   "image"
      t.integer  "user_id"
      t.integer  "landmark_id"
      t.datetime "created_at",                                           :null => false
      t.datetime "updated_at",                                           :null => false
      t.spatial  "geom",        :limit => {:srid=>4326, :type=>"point"}
    end

    add_index "events", ["landmark_id"], :name => "index_events_on_landmark_id"
    add_index "events", ["user_id"], :name => "index_events_on_user_id"

    create_table "geo_units", :force => true do |t|
      t.integer  "osm_id",     :limit => 8
      t.string   "osm_type"
      t.string   "type"
      t.datetime "created_at",              :null => false
      t.datetime "updated_at",              :null => false
    end

    add_index "geo_units", ["osm_id"], :name => "index_geo_units_on_osm_id"

    create_table "images", :force => true do |t|
      t.string   "image"
      t.string   "state"
      t.string   "imageable_type"
      t.integer  "imageable_id"
      t.datetime "created_at",     :null => false
      t.datetime "updated_at",     :null => false
    end

    add_index "images", ["imageable_id"], :name => "index_images_on_imageable_id"

    create_table "profiles", :force => true do |t|
      t.string   "name"
      t.string   "avatar"
      t.string   "slug"
      t.hstore   "settings"
      t.integer  "user_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "profiles", ["slug"], :name => "index_profiles_on_slug"
    add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

    create_table "reviews", :force => true do |t|
      t.string   "title"
      t.text     "body"
      t.integer  "user_id"
      t.integer  "reviewable_id"
      t.string   "reviewable_type"
      t.string   "state"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
    end

    add_index "reviews", ["reviewable_id"], :name => "index_reviews_on_reviewable_id"
    add_index "reviews", ["user_id"], :name => "index_reviews_on_user_id"

    create_table "taggings", :force => true do |t|
      t.integer  "tag_id"
      t.integer  "taggable_id"
      t.string   "taggable_type"
      t.integer  "tagger_id"
      t.string   "tagger_type"
      t.string   "context",       :limit => 128
      t.datetime "created_at"
    end

    add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
    add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

    create_table "tags", :force => true do |t|
      t.string "name"
    end

    create_table "user_sessions", :force => true do |t|
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "users", :force => true do |t|
      t.string   "email",                  :default => "", :null => false
      t.string   "encrypted_password",     :default => "", :null => false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email"
      t.string   "provider"
      t.string   "uid"
      t.string   "state"
      t.integer  "roles"
      t.datetime "created_at",                             :null => false
      t.datetime "updated_at",                             :null => false
    end

    add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

    create_table "votes", :force => true do |t|
      t.boolean  "vote",          :default => false, :null => false
      t.integer  "voteable_id",                      :null => false
      t.string   "voteable_type",                    :null => false
      t.integer  "voter_id"
      t.string   "voter_type"
      t.datetime "created_at",                       :null => false
      t.datetime "updated_at",                       :null => false
      t.string   "voteable_tag"
    end

    add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
    add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type", "voteable_tag"], :name => "fk_one_vote_per_user_per_entity", :unique => true
    add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"
  end
  def down
    execute "DROP EXTENSION IF EXISTS hstore"
    drop_table :abstract_descriptions
    drop_table :authentications
    drop_table :categories
    drop_table :comments
    drop_table :complaints
    drop_table :event_occurrences
    drop_table :events
    drop_table :geo_units
    drop_table :images
    drop_table :profiles
    drop_table :reviews
    drop_table :taggings
    drop_table :tags
    drop_table :user_sessions
    drop_table :users
    drop_table :votes
  end
end
