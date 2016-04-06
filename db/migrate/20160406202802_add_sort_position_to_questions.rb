class AddSortPositionToQuestions < ActiveRecord::Migration
  def change
    add_sortable_column :questions, null: true

    # Assign question positions
    reversible do |dir|
      dir.up do
        Exercise.preload(:questions).find_each do |exercise|
          exercise.questions.sort_by(&:id).each_with_index do |question, index|
            question.update_attribute(:sort_position, index + 1)
          end
        end
      end
    end

    change_column_null :questions, :sort_position, false
    add_sortable_index :questions, scope: :exercise_id
  end
end
