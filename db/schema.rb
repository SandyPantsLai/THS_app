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

ActiveRecord::Schema.define(version: 20150529193724) do

  create_table "book_copies", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "library_code"
    t.string   "condition"
    t.string   "format"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "books", force: :cascade do |t|
    t.string  "title"
    t.integer "published"
    t.string  "publisher"
    t.integer "page_count"
    t.integer "price"
    t.text    "description"
    t.string  "cover_image"
    t.string  "isbn"
    t.integer "hold_id"
    t.string  "first_name"
    t.string  "last_name"
    t.integer "subject_id"
    t.string  "qr_code_uid"
  end

  create_table "check_outs", force: :cascade do |t|
    t.datetime "checkout_date"
    t.datetime "due_date"
    t.integer  "user_id"
    t.integer  "book_copy_id"
    t.integer  "renewal"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "return_date"
  end

  create_table "deposits", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.datetime "settlement_date"
    t.integer  "charge_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "fines", force: :cascade do |t|
    t.integer  "amount"
    t.datetime "settlement_date"
    t.integer  "check_out_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "holds", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "pickup_expiry"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "member_fees", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.datetime "settlement_date"
    t.integer  "charge_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                              null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "role"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.integer  "failed_logins_count",             default: 0
    t.datetime "lock_expires_at"
    t.string   "unlock_token"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "stripe_id"
    t.integer  "current_deposit"
    t.string   "membership"
    t.string   "status",                          default: "active"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token"
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token"

end
