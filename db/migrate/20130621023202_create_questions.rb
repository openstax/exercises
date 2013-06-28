class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :exercise_id
      t.text :content, :null => false, :default => ''
      t.text :content_cache, :null => false, :default => ''
      t.integer :number, :null => false
      t.decimal :credit
      t.boolean :changes_solution, :null => false, :default => false
      t.integer :source_question_id

      t.timestamps
    end

    add_index :questions, [:exercise_id, :number], :unique => true
    add_index :questions, :source_question_id
  end
end
