class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.content
      t.credit
      t.lockable
      t.publishable
      t.integer :embargo_days, null: false, default: 0
      t.date :embargoed_until
      t.boolean :only_embargo_solutions, null: false, default: false
      t.boolean :changes_solutions, null: false, default: false

      t.timestamps
    end

    add_publishable_indexes :exercises
  end
end
