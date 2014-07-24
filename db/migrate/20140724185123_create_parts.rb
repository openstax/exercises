class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.sortable
      t.references :exercise, null: false
      t.text :background

      t.timestamps
    end

    add_sortable_index :parts, :exercise_id
  end
end
