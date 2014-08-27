class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name, null: false
      t.boolean :is_public, null: false, default: false

      t.timestamps
    end

    add_index :lists, :name
  end
end
