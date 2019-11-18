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

ActiveRecord::Schema.define(version: 20191015134004) do

  create_table "bids", force: :cascade do |t|
    t.string "value"
    t.string "window"
    t.integer "round"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
    t.integer "team_id"
    t.index ["player_id"], name: "index_bids_on_player_id"
    t.index ["team_id"], name: "index_bids_on_team_id"
  end

  create_table "gameweeks", force: :cascade do |t|
    t.integer "gameweek"
    t.integer "deadline_time_epoch"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "season"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer "home_team_id"
    t.integer "away_team_id"
    t.integer "gameweek"
    t.integer "home_score", default: 0
    t.integer "away_score", default: 0
    t.integer "home_points", default: 0
    t.integer "away_points", default: 0
    t.boolean "played", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "league_id"
    t.index ["gameweek"], name: "index_matches_on_gameweek"
    t.index ["league_id"], name: "index_matches_on_league_id"
  end

  create_table "player_team_relationships", force: :cascade do |t|
    t.integer "player_id"
    t.integer "team_id"
    t.integer "gameweek_in"
    t.integer "gameweek_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "captain", default: false
  end

  create_table "players", force: :cascade do |t|
    t.string "full_name"
    t.string "common_name"
    t.string "position"
    t.text "gameweek_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "premier_league_team_id"
    t.integer "league_id"
    t.text "picture"
    t.text "status"
    t.text "news"
    t.text "chance_of_playing"
    t.index ["common_name"], name: "index_players_on_common_name"
    t.index ["premier_league_team_id"], name: "index_players_on_premier_league_team_id"
  end

  create_table "premier_league_teams", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "transfers_remaining", default: 3
    t.text "properties"
    t.text "gameweek_scores"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "league_id"
    t.text "gameweek_points"
    t.index ["league_id"], name: "index_teams_on_league_id"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "initials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
