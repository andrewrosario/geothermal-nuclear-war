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

ActiveRecord::Schema.define(version: 4) do

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.integer "population"
    t.string "player"
  end

  create_table "games", force: :cascade do |t|
    t.string "player_name"
  end

  create_table "missiles", force: :cascade do |t|
    t.integer "city_id"
    t.integer "dropped_on"
    t.boolean "active"
    t.integer "game_id"
  end

end
