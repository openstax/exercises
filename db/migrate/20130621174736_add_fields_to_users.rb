class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_admin, :boolean, null: false, default: false
    add_column :users, :disabled_at, :datetime

    add_index :users, :is_admin
    add_index :users, :disabled_at
  end
end
