class CreateMultipleChoiceAnswers < ActiveRecord::Migration
  def change
    create_table :multiple_choice_answers do |t|
      t.content
      t.credit
      t.sortable
      t.belongs_to :question, null: false
      t.boolean :is_always_last, null: false, default: false

      t.timestamps
    end

    add_sortable_index :multiple_choice_answers, :question_id
  end
end
