class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.text :description
      t.string :default_branch

      t.boolean :public
      t.integer :visibility_level

      t.string :ssh_url_to_repo
      t.string :http_url_to_repo
      t.string :web_url

      t.references :owner, index: true

      t.string :name
      t.string :name_with_namespace

      t.string :path
      t.string :path_with_namespace

      t.boolean :issues_enabled
      t.boolean :merge_requests_enabled
      t.boolean :wall_enabled
      t.boolean :wiki_enabled
      t.boolean :snippets_enabled

      t.integer :namespace_id
      t.string :namespace_name
      t.string :namespace_path

      t.datetime :created_at
      t.datetime :last_activity_at
    end
  end
end
