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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180221063535) do

  create_table "users", force: :cascade do |t|
    t.string   "uuid",          limit: 100, null: false, comment: "UUID"
    t.string   "name",          limit: 100, null: false, comment: "ユーザ-名"
    t.integer  "device_type",               null: false, comment: "デバイス種別"
    t.integer  "user_type",                 null: false, comment: "ユーザ-タイプ"
    t.datetime "registered_at",             null: false, comment: "作成日"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "users", ["uuid"], name: "index_users_on_uuid", unique: true

end
