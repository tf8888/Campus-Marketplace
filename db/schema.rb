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

ActiveRecord::Schema[8.0].define(version: 2025_11_04_200440) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "condition"
    t.boolean "available"
    t.boolean "for_lend"
    t.boolean "for_sale"
    t.string "location"
    t.string "image_url"
    t.integer "user_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 10, scale: 2
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["title"], name: "index_items_on_title"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.boolean "read"
    t.integer "request_id", null: false
    t.integer "sender_id", null: false
    t.integer "receiver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["request_id"], name: "index_messages_on_request_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "score", null: false
    t.integer "rater_id", null: false
    t.integer "ratee_id", null: false
    t.integer "request_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ratee_id"], name: "index_ratings_on_ratee_id"
    t.index ["rater_id", "request_id"], name: "index_ratings_on_rater_id_and_request_id", unique: true
    t.index ["rater_id"], name: "index_ratings_on_rater_id"
    t.index ["request_id"], name: "index_ratings_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "user_id", null: false
    t.string "status"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id", "user_id"], name: "index_requests_on_item_id_and_user_id", unique: true
    t.index ["item_id"], name: "index_requests_on_item_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "address"
    t.string "contact_number"
    t.boolean "verified", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["uid"], name: "index_users_on_uid"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "users"
  add_foreign_key "messages", "requests"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "ratings", "requests"
  add_foreign_key "ratings", "users", column: "ratee_id"
  add_foreign_key "ratings", "users", column: "rater_id"
  add_foreign_key "requests", "items"
  add_foreign_key "requests", "users"
end
