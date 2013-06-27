class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name
      t.boolean :is_public
      t.integer :parent_list_id
      t.integer :reader_user_group_id
      t.integer :editor_user_group_id
      t.integer :publisher_user_group_id
      t.integer :manager_user_group_id

      t.timestamps
    end

    add_index :lists, :name, :unique => true
    add_index :lists, :parent_list_id
  end
end
