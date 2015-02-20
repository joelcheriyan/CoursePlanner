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

ActiveRecord::Schema.define(version: 20150212221552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "degree_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "course_code"
    t.string   "course_name"
    t.text     "course_description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "courses_user", force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
  end

  add_index "courses_user", ["course_id", "user_id"], name: "index_courses_user_on_course_id_and_user_id", using: :btree

  create_table "courses_users", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
  end

  add_index "courses_users", ["course_id"], name: "index_courses_users_on_course_id", using: :btree
  add_index "courses_users", ["user_id"], name: "index_courses_users_on_user_id", using: :btree

  create_table "degrees", force: :cascade do |t|
    t.string   "degree_name"
    t.integer  "degree_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "degrees_user", force: :cascade do |t|
    t.integer "degree_id"
    t.integer "user_id"
  end

  add_index "degrees_user", ["degree_id", "user_id"], name: "index_degrees_user_on_degree_id_and_user_id", using: :btree

  create_table "degrees_users", id: false, force: :cascade do |t|
    t.integer "degree_id"
    t.integer "user_id"
  end

  add_index "degrees_users", ["degree_id"], name: "index_degrees_users_on_degree_id", using: :btree
  add_index "degrees_users", ["user_id"], name: "index_degrees_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end