class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.publishable
      t.references :logic
      t.string :title
      t.text :background
      t.datetime :embargoed_until
      t.boolean :embargo_solutions_only, null: false, default: false
      t.boolean :changes_solutions, null: false, default: false

      t.timestamps
    end

    add_publishable_indexes :exercises
    add_index :exercises, :embargoed_until
  end
end
