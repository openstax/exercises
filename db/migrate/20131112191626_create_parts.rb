class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.integer :exercise_id
      t.integer :background_id
      t.integer :position
      t.float :credit

      t.timestamps
    end

    add_index :parts, :exercise_id
    add_index :parts, :background_id
  end
end
