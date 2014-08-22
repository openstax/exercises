class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.text :background, null: false, default: ''
      t.string :title
      t.datetime :embargo_until
      t.boolean :only_embargo_solutions, null: false, default: false
      t.boolean :changes_solutions, null: false, default: false

      t.timestamps
    end

    add_index :exercises, :embargo_until
  end
end
