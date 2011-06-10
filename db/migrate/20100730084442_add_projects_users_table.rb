class AddProjectsUsersTable < ActiveRecord::Migration
  def self.up
    create_table "projects_users", :id => false, :force => true do |t|
      t.integer "project_id"
      t.integer "user_id"
    end
  end
  
  def self.down
    drop_table :projects_users
  end
end
