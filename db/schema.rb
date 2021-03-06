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

ActiveRecord::Schema.define(version: 20171109140132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "category_maps", force: :cascade do |t|
    t.string "kktwon_category"
    t.string "kktwon_sub_category"
    t.string "carousell_category"
    t.string "carousell_sub_category"
    t.string "carousell_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "uri"
    t.string "filename"
    t.integer "size"
    t.integer "image_class"
    t.boolean "is_download", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_item_id"
    t.index ["user_item_id"], name: "index_images_on_user_item_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.boolean "is_profile", default: false
    t.boolean "is_user_item", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_statuses_on_user_id"
  end

  create_table "user_items", force: :cascade do |t|
    t.string "serial_number"
    t.string "category_lv1"
    t.string "category_lv2"
    t.decimal "price"
    t.decimal "original_price"
    t.string "name"
    t.text "description"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.boolean "is_uploaded", default: false
    t.index ["user_id"], name: "index_user_items_on_user_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string "kk_id"
    t.string "serial_number"
    t.string "nickname"
    t.string "profile_url"
    t.string "avatar_url"
    t.string "avatar_url_small"
    t.string "avatar_url_normal"
    t.string "create_time"
    t.integer "rating_good"
    t.integer "rating_neutral"
    t.integer "rating_bad"
    t.integer "total_ratings"
    t.integer "count_of_followers"
    t.integer "count_of_followings"
    t.integer "count_of_on_sale_items"
    t.integer "count_of_sold_items"
    t.boolean "is_following"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "carousell_user"
    t.string "kktown_user"
    t.string "serial_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
  end

end
