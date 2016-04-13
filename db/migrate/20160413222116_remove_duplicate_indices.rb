class RemoveDuplicateIndices < ActiveRecord::Migration
  def change
    remove_index :questions, :exercise_id
    remove_index :answers, :question_id
  end
end
