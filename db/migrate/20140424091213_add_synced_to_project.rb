class AddSyncedToProject < ActiveRecord::Migration
  def change
    add_column :projects, :synced, :boolean, default: true
  end
end
