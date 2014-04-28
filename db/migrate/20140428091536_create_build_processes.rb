class CreateBuildProcesses < ActiveRecord::Migration
  def change
    create_table :build_processes do |t|
      t.references :build, index: true
      t.integer :number, null: false, default: 0

      t.string :name, null: false, default: ''
      t.string :args

      t.index [:build_id, :number]
    end
  end
end
