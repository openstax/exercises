class CreateUserGroupUsers < ActiveRecord::Migration
  def change
    create_table :user_group_users do |t|
      t.integer :position, :null => false
      t.integer :user_group_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :is_manager, :null => false, :default => false

      t.timestamps
    end

    add_index :user_group_users, [:user_group_id, :user_id], :unique => true
    add_index :user_group_users, [:user_id, :position], :unique => true
  end
end
