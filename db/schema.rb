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

ActiveRecord::Schema[8.1].define(version: 2026_04_26_034857) do
  create_schema "extensions"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "public.active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "public.active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "public.active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "public.ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name", unique: true
  end

  create_table "public.meal_plan_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "day_of_week", null: false
    t.bigint "meal_plan_id", null: false
    t.string "meal_type", null: false
    t.bigint "recipe_id", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_plan_id", "day_of_week", "meal_type"], name: "index_meal_plan_entries_on_slot", unique: true
    t.index ["meal_plan_id"], name: "index_meal_plan_entries_on_meal_plan_id"
    t.index ["recipe_id"], name: "index_meal_plan_entries_on_recipe_id"
  end

  create_table "public.meal_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.date "week_start_date", null: false
    t.index ["user_id", "week_start_date"], name: "index_meal_plans_on_user_id_and_week_start_date", unique: true
    t.index ["user_id"], name: "index_meal_plans_on_user_id"
  end

  create_table "public.pantry_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "ingredient_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["ingredient_id"], name: "index_pantry_items_on_ingredient_id"
    t.index ["user_id", "ingredient_id"], name: "index_pantry_items_on_user_id_and_ingredient_id", unique: true
    t.index ["user_id"], name: "index_pantry_items_on_user_id"
  end

  create_table "public.recipe_ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "ingredient_id", null: false
    t.decimal "quantity", precision: 8, scale: 2, null: false
    t.bigint "recipe_id", null: false
    t.string "unit", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id", "ingredient_id"], name: "index_recipe_ingredients_on_recipe_id_and_ingredient_id", unique: true
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "public.recipe_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "recipe_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id", "tag_id"], name: "index_recipe_tags_on_recipe_id_and_tag_id", unique: true
    t.index ["recipe_id"], name: "index_recipe_tags_on_recipe_id"
    t.index ["tag_id"], name: "index_recipe_tags_on_tag_id"
  end

  create_table "public.recipes", force: :cascade do |t|
    t.integer "cook_time"
    t.datetime "created_at", null: false
    t.text "description"
    t.text "instructions", null: false
    t.integer "prep_time"
    t.boolean "public", default: false, null: false
    t.integer "servings"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "public.tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "public.users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "public.active_storage_attachments", "public.active_storage_blobs", column: "blob_id"
  add_foreign_key "public.active_storage_variant_records", "public.active_storage_blobs", column: "blob_id"
  add_foreign_key "public.meal_plan_entries", "public.meal_plans"
  add_foreign_key "public.meal_plan_entries", "public.recipes"
  add_foreign_key "public.meal_plans", "public.users"
  add_foreign_key "public.pantry_items", "public.ingredients"
  add_foreign_key "public.pantry_items", "public.users"
  add_foreign_key "public.recipe_ingredients", "public.ingredients"
  add_foreign_key "public.recipe_ingredients", "public.recipes"
  add_foreign_key "public.recipe_tags", "public.recipes"
  add_foreign_key "public.recipe_tags", "public.tags"
  add_foreign_key "public.recipes", "public.users"

end
