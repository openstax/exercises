class CreateUserGroupMembers < ActiveRecord::Migration
  def change
    create_table :user_group_members do |t|
      t.integer :user_group_id
      t.integer :user_id
      t.boolean :is_manager

      t.timestamps
    end

    add_index :user_group_members, [:user_group_id, :user_id], :unique => true
  end
end
