class CreateListExercises < ActiveRecord::Migration
  def change
    create_table :list_exercises do |t|
      t.integer :list_id
      t.integer :exercise_id

      t.timestamps
    end
  end
end
