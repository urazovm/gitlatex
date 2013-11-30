class CreateBuildedFiles < ActiveRecord::Migration
  def change
    create_table :builded_files do |t|
      t.string :name
      t.string :path
      t.references :build, index: true

      t.timestamps
    end
  end
end
