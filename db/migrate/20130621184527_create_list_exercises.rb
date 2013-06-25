class CreateListExercises < ActiveRecord::Migration
  def change
    create_table :list_exercises do |t|
      t.integer :list_id
      t.integer :exercise_id
      t.integer :number

      t.timestamps
    end

    add_index :list_exercises, [:list_id, :exercise_id], :unique => true
    add_index :list_exercises, :exercise_id
  end
end
