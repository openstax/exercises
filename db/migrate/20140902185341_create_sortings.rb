class CreateSortings < ActiveRecord::Migration
  def change
    create_table :sortings do |t|
      t.references :sortable, polymorphic: true, null: false
      t.references :user, null: false
      t.integer :position, null: false

      t.timestamps null: false
    end

    add_index :sortings, [:sortable_id, :sortable_type, :user_id], unique: true
    add_index :sortings, [:user_id, :sortable_type, :position], unique: true
  end
end
