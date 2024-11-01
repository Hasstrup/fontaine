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

ActiveRecord::Schema.define(version: 2024_10_29_150811) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "templates_components", force: :cascade do |t|
    t.string "title", null: false
    t.string "key_tag"
    t.string "key_type"
    t.string "text_accessor"
    t.bigint "template_id"
    t.jsonb "metadata"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["template_id"], name: "index_templates_components_on_template_id"
  end

  create_table "templates_templates", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "user_id"
    t.string "reference_file_path"
    t.string "reference_file_name"
    t.jsonb "metadata"
    t.text "html_content"
    t.jsonb "instructions"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_templates_templates_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "token"
    t.string "type"
    t.string "owner_type"
    t.integer "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "templates_components", "templates_templates", column: "template_id"
end
