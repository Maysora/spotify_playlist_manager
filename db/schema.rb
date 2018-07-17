# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180115082006) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "multi_playlist_tracks", force: :cascade do |t|
    t.bigint "multi_playlist_id", null: false
    t.string "spotify_id"
    t.string "spotify_uri"
    t.string "source_playlist_spotify_id"
    t.string "name"
    t.string "album_name"
    t.string "artist_name"
    t.boolean "local", default: false, null: false
    t.datetime "last_sync_at", null: false
    t.index ["multi_playlist_id"], name: "index_multi_playlist_tracks_on_multi_playlist_id"
  end

  create_table "multi_playlists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "spotify_id", null: false
    t.string "owner_id", null: false
    t.string "name"
    t.text "description"
    t.string "image_url"
    t.boolean "public", default: false, null: false
    t.integer "tracks_count"
    t.string "playlist_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_multi_playlists_on_user_id"
  end

  create_table "spotify_configurations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_spotify_configurations_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname"
    t.string "email", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "spotify_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

end
