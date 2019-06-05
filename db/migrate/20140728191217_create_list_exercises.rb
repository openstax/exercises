class CreateListExercises < ActiveRecord::Migration[4.2]
  def change
    create_table :list_exercises do |t|
      t.sortable
      t.references :list, null: false
      t.references :exercise, null: false

      t.timestamps null: false
    end

    add_sortable_index :list_exercises, scope: :list_id
    add_index :list_exercises, [:exercise_id, :list_id], unique: true
  end
end
