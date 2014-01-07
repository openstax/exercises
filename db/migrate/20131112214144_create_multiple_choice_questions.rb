class CreateMultipleChoiceQuestions < ActiveRecord::Migration
  def change
    create_table :multiple_choice_questions do |t|
      t.integer :stem_id, null: false
      t.boolean :can_select_multiple, null: false

      t.timestamps
    end

    add_index :multiple_choice_questions, :stem_id
    add_index :multiple_choice_questions, :can_select_multiple
  end
end
