class MoveProfileInfoToUser < ActiveRecord::Migration
  def up
    add_column :users, :default_list_id, :integer
    change_column :users, :default_list_id, :integer, null: false

    add_column :users, :auto_author_subscribe, :boolean, null: false, default: false
    add_column :users, :collaborator_request_email, :boolean, null: false, default: false
    add_column :users, :user_group_member_email, :boolean, null: false, default: false

    add_index :users, :default_list_id

    remove_index :user_profiles, :default_list_id
    remove_index :user_profiles, :user_id

    drop_table :user_profiles
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
