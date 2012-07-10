# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100730084442) do

  create_table "config_list", :id => false, :force => true do |t|
    t.integer "ip",                     :null => false
    t.integer "port",     :limit => 3,  :null => false
    t.integer "server",                 :null => false
    t.string  "path",     :limit => 70, :null => false
    t.string  "filename", :limit => 30, :null => false
  end

  add_index "config_list", ["ip", "server"], :name => "ip", :unique => true
  add_index "config_list", ["server"], :name => "server"

  create_table "configuration_parameters", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.integer  "project_id"
    t.integer  "stage_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "prompt_on_deploy", :default => 0
  end

  add_index "configuration_parameters", ["project_id"], :name => "project_id"
  add_index "configuration_parameters", ["stage_id", "project_id"], :name => "stage_id"

  create_table "deployments", :force => true do |t|
    t.string   "task"
    t.text     "log",               :limit => 16777215
    t.integer  "stage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.text     "description"
    t.integer  "user_id"
    t.string   "excluded_host_ids"
    t.string   "revision"
    t.integer  "pid"
    t.string   "status",                                :default => "running"
    t.text     "iplist"
    t.integer  "revert",                                :default => 0
  end

  add_index "deployments", ["created_at"], :name => "idx_created_at"
  add_index "deployments", ["stage_id", "created_at"], :name => "idx_stage_create"
  add_index "deployments", ["stage_id"], :name => "idx_stage_id"
  add_index "deployments", ["user_id"], :name => "user_id"

  create_table "deployments_roles", :id => false, :force => true do |t|
    t.integer "deployment_id"
    t.integer "role_id"
  end

  add_index "deployments_roles", ["deployment_id"], :name => "deployment_id"
  add_index "deployments_roles", ["role_id", "deployment_id"], :name => "role_id"

  create_table "dinfo", :id => false, :force => true do |t|
    t.integer  "sid"
    t.integer  "cnt", :limit => 8, :default => 0, :null => false
    t.datetime "rec"
  end

  create_table "dlists", :id => false, :force => true do |t|
    t.integer  "id",           :default => 0, :null => false
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "d_created_at"
  end

  create_table "gitinfors", :force => true do |t|
    t.string  "project_name"
    t.string  "commit_hash"
    t.integer "locked",       :default => 1
    t.string  "tag_name",     :default => ""
  end

  add_index "gitinfors", ["commit_hash"], :name => "commit_hash"

  create_table "hosts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
    t.integer  "ipcnt",      :default => 0
    t.integer  "project_id"
  end

  add_index "hosts", ["project_id"], :name => "project_id"

  create_table "pinfos", :id => false, :force => true do |t|
    t.integer  "id",                                                       :default => 0, :null => false
    t.string   "name"
    t.text     "description"
    t.integer  "nss",         :limit => 8,                                 :default => 0, :null => false
    t.integer  "nds",         :limit => 41, :precision => 41, :scale => 0
    t.datetime "updated_at"
    t.datetime "mrec"
  end

  create_table "project_configurations", :force => true do |t|
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "template"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "recipe_versions", :force => true do |t|
    t.integer  "recipe_id"
    t.integer  "version"
    t.string   "name"
    t.text     "body"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",     :default => 1
    t.integer  "project_id"
  end

  add_index "recipes", ["project_id"], :name => "project_id"

  create_table "recipes_stages", :id => false, :force => true do |t|
    t.integer "recipe_id"
    t.integer "stage_id"
  end

  add_index "recipes_stages", ["recipe_id"], :name => "recipe_id"
  add_index "recipes_stages", ["stage_id", "recipe_id"], :name => "stage_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "stage_id"
    t.integer  "host_id"
    t.integer  "primary",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "no_release", :default => 0
    t.integer  "ssh_port"
    t.integer  "no_symlink", :default => 0
  end

  add_index "roles", ["host_id"], :name => "host_id"
  add_index "roles", ["stage_id"], :name => "stage_id"

  create_table "sdinfo", :id => false, :force => true do |t|
    t.integer  "id",                      :default => 0, :null => false
    t.integer  "project_id"
    t.integer  "cnt",        :limit => 8, :default => 0, :null => false
    t.datetime "rec"
  end

  create_table "server_list", :force => true do |t|
    t.string "name",             :limit => 30, :null => false
    t.string "default_path",     :limit => 70, :null => false
    t.string "default_filename", :limit => 30, :null => false
  end

  add_index "server_list", ["name"], :name => "name", :unique => true

  create_table "stage_configurations", :force => true do |t|
  end

  create_table "stages", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "alert_emails"
    t.integer  "locked_by_deployment_id"
    t.integer  "locked",                  :default => 0
    t.string   "demander"
    t.string   "task_sn"
    t.string   "descrips"
  end

  add_index "stages", ["project_id"], :name => "project_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "admin",                                   :default => 0
    t.string   "time_zone",                               :default => "UTC"
    t.datetime "disabled"
    t.string   "nick",                      :limit => 20
  end

  add_index "users", ["disabled"], :name => "index_users_on_disabled"

  create_table "wrong_deployments", :id => false, :force => true do |t|
    t.integer  "id",                                    :default => 0,         :null => false
    t.string   "task"
    t.text     "log",               :limit => 16777215
    t.integer  "stage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.text     "description"
    t.integer  "user_id"
    t.string   "excluded_host_ids"
    t.string   "revision"
    t.integer  "pid"
    t.string   "status",                                :default => "running"
    t.text     "iplist"
  end

end
