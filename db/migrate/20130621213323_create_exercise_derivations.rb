class CreateExerciseDerivations < ActiveRecord::Migration
  def change
    create_table :exercise_derivations do |t|
      t.integer :derived_exercise_id
      t.integer :source_exercise_id

      t.timestamps
    end

    add_index :exercise_derivations, :source_exercise_id
    add_index :exercise_derivations, :derived_exercise_id
  end
end
