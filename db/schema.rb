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

ActiveRecord::Schema[8.0].define(version: 2025_10_22_082157) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "entry_values", force: :cascade do |t|
    t.string "string_value"
    t.integer "integer_value"
    t.datetime "datetime_value"
    t.bigint "form_entry_id", null: false
    t.bigint "form_field_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_entry_id"], name: "index_entry_values_on_form_entry_id"
    t.index ["form_field_id"], name: "index_entry_values_on_form_field_id"
  end

  create_table "fields", force: :cascade do |t|
    t.string "name"
    t.integer "field_type", default: 0, null: false
    t.integer "min_length"
    t.integer "max_length"
    t.integer "min_value"
    t.integer "max_value"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_fields_on_user_id"
  end

  create_table "form_entries", force: :cascade do |t|
    t.bigint "form_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["form_id"], name: "index_form_entries_on_form_id"
  end

  create_table "form_fields", force: :cascade do |t|
    t.bigint "form_id", null: false
    t.bigint "field_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_form_fields_on_field_id"
    t.index ["form_id"], name: "index_form_fields_on_form_id"
  end

  create_table "forms", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_forms_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "entry_values", "form_entries"
  add_foreign_key "entry_values", "form_fields"
  add_foreign_key "fields", "users"
  add_foreign_key "form_entries", "forms"
  add_foreign_key "form_fields", "fields"
  add_foreign_key "form_fields", "forms"
  add_foreign_key "forms", "users"
  add_foreign_key "sessions", "users"
end
