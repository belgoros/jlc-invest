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

ActiveRecord::Schema.define(version: 2014_05_30_080400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.integer "client_id"
    t.string "acc_number", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", id: :serial, force: :cascade do |t|
    t.string "firstname", limit: 255
    t.string "lastname", limit: 255
    t.string "email", limit: 255
    t.string "password_digest", limit: 255
    t.string "remember_token", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["remember_token"], name: "index_admins_on_remember_token"
  end

  create_table "clients", id: :serial, force: :cascade do |t|
    t.string "firstname", limit: 255
    t.string "lastname", limit: 255
    t.string "phone", limit: 255
    t.string "street", limit: 255
    t.string "house", limit: 255
    t.string "box", limit: 255
    t.string "zipcode", limit: 255
    t.string "city", limit: 255
    t.string "country", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operations", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.string "operation_type", limit: 255
    t.date "value_date"
    t.date "close_date"
    t.decimal "sum", precision: 10, scale: 2
    t.decimal "rate", precision: 5, scale: 2
    t.decimal "withholding", precision: 5, scale: 2
    t.integer "duration"
    t.decimal "interests", precision: 10, scale: 2
    t.decimal "total", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
