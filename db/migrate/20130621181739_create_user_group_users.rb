class CreateUserGroupUsers < ActiveRecord::Migration
  def change
    create_table :user_group_users do |t|
      t.sortable
      t.belongs_to :user_group, null: false
      t.belongs_to :user, null: false
      t.boolean :is_manager, null: false, default: false

      t.timestamps
    end

    add_sortable_index :user_group_users, :user_id
    add_index :user_group_users, [:user_group_id, :user_id], unique: true
  end
end
