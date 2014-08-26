class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :title
      t.text :background

      t.timestamps
    end

    add_index :exercises, :title
  end
end
