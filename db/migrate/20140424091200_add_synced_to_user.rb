class AddSyncedToUser < ActiveRecord::Migration
  def change
    add_column :users, :synced, :boolean, default: true
  end
end
