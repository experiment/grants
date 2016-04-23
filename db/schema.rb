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

ActiveRecord::Schema.define(version: 20160423211037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "funders", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "funders", ["name"], name: "index_funders_on_name", unique: true, using: :btree
  add_index "funders", ["url"], name: "index_funders_on_url", using: :btree

  create_table "opportunities", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "funder_id",              null: false
    t.datetime "posted_at"
    t.datetime "due_at"
    t.string   "location"
    t.integer  "number_of_recipients"
    t.integer  "min_amount"
    t.integer  "max_amount"
    t.integer  "total_amount"
    t.text     "description"
    t.string   "url"
    t.string   "foreign_key",            null: false
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "eligibility_categories"
    t.integer  "first_source_id",        null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "opportunities", ["funder_id", "foreign_key"], name: "index_opportunities_on_funder_id_and_foreign_key", unique: true, using: :btree

  create_table "sources", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "url",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sources", ["name"], name: "index_sources_on_name", unique: true, using: :btree
  add_index "sources", ["url"], name: "index_sources_on_url", using: :btree

end
