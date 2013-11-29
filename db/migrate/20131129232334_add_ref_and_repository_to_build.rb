class AddRefAndRepositoryToBuild < ActiveRecord::Migration
  def change
    add_column :builds, :ref, :string
    add_column :builds, :repository_name, :string
    add_column :builds, :repository_url, :string
    add_column :builds, :repository_description, :text
    add_column :builds, :repository_homepage, :string
  end
end
