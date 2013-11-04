class CreateListExercises < ActiveRecord::Migration
  def change
    create_table :list_exercises do |t|
      t.sortable
      t.belongs_to :list, null: false
      t.belongs_to :exercise, null: false

      t.timestamps
    end

    add_sortable_index :list_exercises, :list_id
    add_index :list_exercises, [:exercise_id, :list_id], unique: true
  end
end
