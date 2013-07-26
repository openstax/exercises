class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.integer :parent_list_id
      t.integer :reader_user_group_id, :null => false
      t.integer :editor_user_group_id, :null => false
      t.integer :publisher_user_group_id, :null => false
      t.integer :owner_user_group_id, :null => false
      t.string :name, :null => false, :default => ''
      t.boolean :is_public, :null => false, :default => false

      t.timestamps
    end

    add_index :lists, :parent_list_id
  end
end
