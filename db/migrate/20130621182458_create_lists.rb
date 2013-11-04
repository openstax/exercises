class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.belongs_to :parent_list
      t.belongs_to :reader_user_group, null: false
      t.belongs_to :editor_user_group, null: false
      t.belongs_to :publisher_user_group, null: false
      t.belongs_to :owner_user_group, null: false
      t.string :name, null: false, default: ''
      t.boolean :is_public, null: false, default: false

      t.timestamps
    end

    add_index :lists, :parent_list_id
  end
end
