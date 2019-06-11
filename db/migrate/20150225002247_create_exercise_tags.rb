class CreateExerciseTags < ActiveRecord::Migration[4.2]
  def change
    create_table :exercise_tags do |t|
      t.references :exercise, null: false
      t.references :tag, null: false

      t.timestamps null: false

      t.index [:exercise_id, :tag_id], unique: true
      t.index :tag_id
    end

    add_foreign_key :exercise_tags, :exercises, on_update: :cascade,
                                                on_delete: :cascade
    add_foreign_key :exercise_tags, :tags, on_update: :cascade,
                                           on_delete: :cascade
  end
end
