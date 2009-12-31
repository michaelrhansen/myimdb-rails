# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091231101246) do

  create_table "activities", :force => true do |t|
    t.string   "content"
    t.string   "type",       :limit => 50
    t.integer  "user_id"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medias", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.string   "source_url"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",     :default => 0
  end

  create_table "movie_statuses", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "status_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", :force => true do |t|
    t.string   "name"
    t.integer  "release_year"
    t.string   "tagline"
    t.text     "plot"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "popularity",           :default => 0
    t.integer  "movie_statuses_count", :default => 0
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.string   "imdb_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "follower_id"
    t.boolean  "is_friend",            :default => false
    t.boolean  "friendship_requested", :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.string   "type"
    t.float    "rating"
    t.integer  "votes",               :default => 1, :null => false
    t.text     "body"
    t.string   "resource_identifier"
    t.string   "resource_url"
    t.integer  "movie_id",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "twitter_username",      :limit => 50, :null => false
    t.string   "twitter_id",                          :null => false
    t.string   "twitter_profile_image"
    t.string   "twitter_token",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
