# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121027130032) do

  create_table "admins", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "clients", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "phone"
    t.string   "street"
    t.string   "house"
    t.string   "box"
    t.string   "zipcode"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "operations", :force => true do |t|
    t.integer  "client_id"
    t.string   "operation_type"
    t.date     "value_date"
    t.decimal  "sum",            :precision => 10, :scale => 2
    t.decimal  "rate",           :precision => 5,  :scale => 2
    t.integer  "duration"
    t.decimal  "interests",      :precision => 10, :scale => 2
    t.decimal  "total",          :precision => 10, :scale => 2
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.date     "close_date"
    t.decimal  "withholding",    :precision => 5,  :scale => 2
  end

end
