class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.integer :deputy_user_group_id
      t.integer :default_list_id
      t.boolean :auto_author_subscribe
      t.boolean :announcement_email
      t.boolean :collaborator_request_email
      t.boolean :user_group_member_email

      t.timestamps
    end

    add_index :user_profiles, :user_id, :unique => true
    add_index :user_profiles, :default_list_id
  end
end
