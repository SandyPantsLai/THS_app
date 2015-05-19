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

ActiveRecord::Schema.define(version: 20150519192538) do

  create_table "book_copies", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "library_code"
    t.string   "condition"
    t.string   "format"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "books", force: :cascade do |t|
    t.string   "author"
    t.string   "title"
    t.string   "subject"
    t.datetime "published"
    t.string   "publisher"
    t.integer  "page_count"
    t.integer  "price"
    t.text     "description"
    t.string   "cover_image"
    t.string   "isbn"
    t.integer  "book_copy_id"
    t.integer  "hold_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "check_outs", force: :cascade do |t|
    t.datetime "checkout_date"
    t.datetime "due_date"
    t.integer  "user_id"
    t.integer  "book_copy_id"
    t.integer  "renewal"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
