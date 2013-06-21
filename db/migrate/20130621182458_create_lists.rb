class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name
      t.integer :reader_user_group_id
      t.integer :editor_user_group_id
      t.integer :publisher_user_group_id
      t.integer :manager_user_group_id

      t.timestamps
    end
  end
end
