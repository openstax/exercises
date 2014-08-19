class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.publishable
      t.logic
      t.text :background, null: false, default: ''
      t.string :title
      t.datetime :embargo_until
      t.boolean :only_embargo_solutions, null: false, default: false
      t.boolean :changes_solutions, null: false, default: false

      t.timestamps
    end

    add_publishable_indexes :exercises
    add_logic_index :exercises
    add_index :exercises, :embargo_until
  end
end
