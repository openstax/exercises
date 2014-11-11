class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :title
      t.text :stimulus

      t.timestamps null: false
    end

    add_index :exercises, :title
  end
end
