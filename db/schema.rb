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

ActiveRecord::Schema[8.0].define(version: 2025_09_02_171704) do
  create_table "feedbacks", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "rating"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_feedbacks_on_order_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.string "unit"
    t.date "expiry_date"
    t.integer "supplier_id", null: false
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_id"], name: "index_inventory_items_on_supplier_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.text "ingredients"
    t.date "menu_date"
    t.string "status"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "menu_item_id", null: false
    t.integer "quantity"
    t.decimal "unit_price"
    t.decimal "subtotal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "index_order_items_on_menu_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "table_id", null: false
    t.string "customer_name"
    t.string "status"
    t.decimal "total_amount"
    t.datetime "order_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_orders_on_table_id"
  end

  create_table "storekeeper_transactions", force: :cascade do |t|
    t.string "transaction_id"
    t.integer "supplier_id", null: false
    t.date "date", null: false
    t.time "time", null: false
    t.string "item", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
    t.index ["supplier_id"], name: "index_storekeeper_transactions_on_supplier_id"
    t.index ["transaction_id"], name: "index_storekeeper_transactions_on_transaction_id", unique: true
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "supplier_code", null: false
    t.string "name", null: false
    t.string "phone_number"
    t.text "address"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplier_code"], name: "index_suppliers_on_supplier_code", unique: true
  end

  create_table "tables", force: :cascade do |t|
    t.integer "table_number"
    t.string "status"
    t.string "qr_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 50, null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", default: "customer", null: false
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.string "phone", limit: 20
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["status"], name: "index_users_on_status"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "feedbacks", "orders"
  add_foreign_key "inventory_items", "suppliers"
  add_foreign_key "order_items", "menu_items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "tables"
  add_foreign_key "storekeeper_transactions", "suppliers"
end
