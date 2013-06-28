class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.string :name
      t.integer :parent_object_id
      t.string :parent_object_type

      t.timestamps
    end
  end
end
