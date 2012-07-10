class CreateGitinfors < ActiveRecord::Migration
  def self.up
    create_table :gitinfors do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :gitinfors
  end
end
