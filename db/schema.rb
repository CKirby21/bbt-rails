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

ActiveRecord::Schema[8.0].define(version: 2024_10_03_210138) do
  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "comments", force: :cascade do |t|
    t.string "commenter"
    t.text "body"
    t.integer "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["article_id"], name: "index_comments_on_article_id"
  end

  create_table "event_scores", force: :cascade do |t|
    t.float "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_id", null: false
    t.integer "event_id", null: false
    t.index ["event_id", "team_id"], name: "index_event_scores_on_event_id_and_team_id", unique: true
    t.index ["event_id"], name: "index_event_scores_on_event_id"
    t.index ["team_id"], name: "index_event_scores_on_team_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_of_event"
  end

  create_table "events_teams", id: false, force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "event_id", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "comments", "articles"
  add_foreign_key "event_scores", "events"
  add_foreign_key "event_scores", "teams"
end
