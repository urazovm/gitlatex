class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :project_id
      t.string :status
      t.references :eventable, polymorphic: true

      t.timestamps
    end

    add_index :events, [:project_id, :updated_at]
  end
end
