class CreateExercises < ActiveRecord::Migration[4.2]
  def change
    create_table :exercises do |t|
      t.string :title
      t.text :stimulus

      t.timestamps null: false
    end

    add_index :exercises, :title
  end
end
