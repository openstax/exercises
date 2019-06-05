class CreateQuestions < ActiveRecord::Migration[4.2]
  def change
    create_table :questions do |t|
      t.references :exercise, null: false
      t.text :stimulus

      t.timestamps null: false
    end

    add_index :questions, :exercise_id
  end
end
