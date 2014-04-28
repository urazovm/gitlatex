class CreateBuildLogs < ActiveRecord::Migration
  def change
    create_table :build_logs do |t|
      t.references :process, index: true
      t.integer :number, null: false, default: 0

      t.string :command, null: false, default: ''
      t.text :log, length: 4294967295

      t.index [:process_id, :number]
    end
  end
end
