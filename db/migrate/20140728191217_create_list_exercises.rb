class CreateListExercises < ActiveRecord::Migration
  def change
    create_table :list_exercises do |t|
      t.sortable
      t.references :list, null: false
      t.references :exercise, null: false
      t.decimal :credit, precision: 5, scale: 2

      t.timestamps
    end

    add_sortable_index :list_exercises, :list_id
    add_index :list_exercises, [:exercise_id, :list_id], unique: true
    add_index :list_exercises, :credit
  end
end
