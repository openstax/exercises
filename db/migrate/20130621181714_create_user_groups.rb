class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.string :name, :null => false, :default => ''
      t.integer :container_id
      t.string :container_type

      t.timestamps
    end

    add_index :user_groups, [:container_type, :container_id]
  end
end
