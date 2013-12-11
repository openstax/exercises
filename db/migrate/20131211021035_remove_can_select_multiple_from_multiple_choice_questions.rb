class RemoveCanSelectMultipleFromMultipleChoiceQuestions < ActiveRecord::Migration
  def up
    remove_index "multiple_choice_questions", ["can_select_multiple"]
    remove_column :multiple_choice_questions, :can_select_multiple
  end

  def down
    add_column :multiple_choice_questions, :can_select_multiple, :boolean
  end
end
