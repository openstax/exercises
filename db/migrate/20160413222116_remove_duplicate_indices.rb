class RemoveDuplicateIndices < ActiveRecord::Migration[4.2]
  def change
    remove_index :questions, :exercise_id
    remove_index :answers, :question_id
  end
end
