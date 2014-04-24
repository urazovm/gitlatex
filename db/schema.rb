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

ActiveRecord::Schema.define(version: 20140424121607) do

  create_table "builded_files", force: true do |t|
    t.string   "name"
    t.string   "path"
    t.integer  "build_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "builded_files", ["build_id"], name: "index_builded_files_on_build_id", using: :btree

  create_table "builds", force: true do |t|
    t.integer  "project_id"
    t.string   "commit_id"
    t.text     "commit_message"
    t.datetime "commit_timestamp"
    t.string   "commit_url"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "status"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ref"
    t.string   "repository_name"
    t.string   "repository_url"
    t.text     "repository_description"
    t.string   "repository_homepage"
    t.text     "error"
  end

  create_table "events", force: true do |t|
    t.integer  "project_id"
    t.string   "status"
    t.integer  "eventable_id"
    t.string   "eventable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["project_id", "updated_at"], name: "index_events_on_project_id_and_updated_at", using: :btree

  create_table "projects", force: true do |t|
    t.text     "description"
    t.string   "default_branch"
    t.boolean  "public"
    t.integer  "visibility_level"
    t.string   "ssh_url_to_repo"
    t.string   "http_url_to_repo"
    t.string   "web_url"
    t.integer  "owner_id"
    t.string   "name"
    t.string   "name_with_namespace"
    t.string   "path"
    t.string   "path_with_namespace"
    t.boolean  "issues_enabled"
    t.boolean  "merge_requests_enabled"
    t.boolean  "wall_enabled"
    t.boolean  "wiki_enabled"
    t.boolean  "snippets_enabled"
    t.integer  "namespace_id"
    t.string   "namespace_name"
    t.string   "namespace_path"
    t.datetime "created_at"
    t.datetime "last_activity_at"
    t.boolean  "synced",                 default: true
  end

  add_index "projects", ["owner_id"], name: "index_projects_on_owner_id", using: :btree

  create_table "user_projects", force: true do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.boolean "synced",     default: true
  end

  add_index "user_projects", ["project_id"], name: "index_user_projects_on_project_id", using: :btree
  add_index "user_projects", ["user_id"], name: "index_user_projects_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "name"
    t.string   "state"
    t.text     "bio"
    t.string   "skype"
    t.string   "linkedin"
    t.string   "twitter"
    t.string   "website_url"
    t.string   "extern_uid"
    t.string   "provider"
    t.integer  "theme_id"
    t.integer  "color_scheme_id"
    t.boolean  "is_admin"
    t.boolean  "can_create_group"
    t.boolean  "can_create_project"
    t.datetime "created_at"
    t.boolean  "synced",             default: true
  end

end
