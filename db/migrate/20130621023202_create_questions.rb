class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :exercise_id
      t.text :content
      t.text :content_html
      t.integer :number
      t.decimal :credit
      t.boolean :changes_solution
      t.integer :source_question_id

      t.timestamps
    end

    add_index :questions, [:exercise_id, :number], :unique => true
    add_index :questions, :source_question_id
  end
end
