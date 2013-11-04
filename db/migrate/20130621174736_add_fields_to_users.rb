class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, null: false, default: ''
    add_column :users, :first_name, :string, null: false, default: ''
    add_column :users, :last_name, :string, null: false, default: ''
    add_column :users, :is_admin, :boolean, null: false, default: false
    add_column :users, :disabled_at, :datetime

    add_index :users, :username, unique: true
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :is_admin
    add_index :users, :disabled_at
  end
end
