# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_03_070229) do
  create_table "interest_logs", force: :cascade do |t|
    t.string "store_id"
    t.integer "user_id"
    t.date "interest_datetime"
    t.integer "interest_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_accounts", force: :cascade do |t|
    t.string "line_user_id"
    t.string "name"
    t.string "picture_url"
    t.string "line_bot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_bot_id", "line_user_id"], name: "index_line_accounts_on_line_bot_id_and_line_user_id", unique: true
  end

  create_table "line_bot_friends", force: :cascade do |t|
    t.string "line_user_id"
    t.integer "line_bot_id"
    t.string "name"
    t.string "picture_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_bot_friends_send_groups", force: :cascade do |t|
    t.integer "line_bot_friend_id", null: false
    t.integer "send_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_bot_friend_id"], name: "index_line_bot_friends_send_groups_on_line_bot_friend_id"
    t.index ["send_group_id"], name: "index_line_bot_friends_send_groups_on_send_group_id"
  end

  create_table "line_bots", force: :cascade do |t|
    t.integer "user_id"
    t.string "line_bot_id"
    t.string "name"
    t.string "picture_url"
    t.string "line_channel_secret"
    t.string "line_channel_token"
    t.string "basic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "send_groups", force: :cascade do |t|
    t.string "group_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "line_bot_id"
    t.integer "created_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "line_user_id"
    t.string "line_bot_friend_id"
  end

  add_foreign_key "line_bot_friends_send_groups", "line_bot_friends"
  add_foreign_key "line_bot_friends_send_groups", "send_groups"
end
