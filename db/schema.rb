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

ActiveRecord::Schema.define(version: 20180427233959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.index ["product_id"], name: "index_categories_on_product_id"
  end

  create_table "category_product", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_category_product_on_category_id"
    t.index ["product_id"], name: "index_category_product_on_product_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "uid"
    t.string "provider"
  end

  create_table "orderproducts", force: :cascade do |t|
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.bigint "order_id"
    t.index ["order_id"], name: "index_orderproducts_on_order_id"
    t.index ["product_id"], name: "index_orderproducts_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status"
    t.string "email"
    t.string "address"
    t.string "card_name"
    t.string "cc_number"
    t.date "cc_expiration"
    t.string "cvv"
    t.string "zip_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "merchant_id"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.bigint "merchant_id"
    t.bigint "orderproduct_id"
    t.string "status"
    t.string "photo"
    t.index ["merchant_id"], name: "index_products_on_merchant_id"
    t.index ["orderproduct_id"], name: "index_products_on_orderproduct_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.index ["product_id"], name: "index_reviews_on_product_id"
  end

  add_foreign_key "categories", "products"
  add_foreign_key "orderproducts", "orders"
  add_foreign_key "orderproducts", "products"
  add_foreign_key "orders", "merchants"
  add_foreign_key "products", "merchants"
  add_foreign_key "products", "orderproducts"
  add_foreign_key "reviews", "products"
end
