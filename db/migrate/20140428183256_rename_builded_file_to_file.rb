class RenameBuildedFileToFile < ActiveRecord::Migration
  def change
    rename_table :builded_files, :files
  end
end
