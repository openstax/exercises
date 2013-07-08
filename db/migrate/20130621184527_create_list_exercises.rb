class CreateListExercises < ActiveRecord::Migration
  def change
    create_table :list_exercises do |t|
      t.integer :position, :null => false
      t.integer :list_id, :null => false
      t.integer :exercise_id, :null => false

      t.timestamps
    end

    add_index :list_exercises, [:list_id, :exercise_id], :unique => true
    add_index :list_exercises, :position
    add_index :list_exercises, :exercise_id
  end
end
