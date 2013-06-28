class CreateUserGroupMembers < ActiveRecord::Migration
  def change
    create_table :user_group_members do |t|
      t.integer :user_group_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :is_manager, :null => false, :default => false

      t.timestamps
    end

    add_index :user_group_members, [:user_group_id, :user_id], :unique => true
  end
end
