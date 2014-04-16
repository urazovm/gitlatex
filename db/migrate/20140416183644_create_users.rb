class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :name
      t.string :state
      
      t.text :bio
      t.string :skype
      t.string :linkedin
      t.string :twitter
      t.string :website_url

      t.string :extern_uid
      t.string :provider

      t.integer :theme_id
      t.integer :color_scheme_id

      t.boolean :is_admin
      t.boolean :can_create_group
      t.boolean :can_create_project

      t.datetime :created_at
    end
  end
end
