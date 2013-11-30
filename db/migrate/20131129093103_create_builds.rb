class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :project_id
      t.string :commit_id
      t.text :commit_message
      t.datetime :commit_timestamp
      t.string :commit_url
      t.string :author_name
      t.string :author_email
      t.string :status
      t.text :log

      t.timestamps
    end
  end
end
