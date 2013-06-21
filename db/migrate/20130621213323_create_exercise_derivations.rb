class CreateExerciseDerivations < ActiveRecord::Migration
  def change
    create_table :exercise_derivations do |t|
      t.exercise_id :derived
      t.integer :source_exercise_id
      t.integer :deriver_id

      t.timestamps
    end
  end
end
