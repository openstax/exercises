class AddSortPositionToQuestions < ActiveRecord::Migration[4.2]
  def change
    add_sortable_column :questions, null: false
    add_sortable_index :questions, scope: :exercise_id
  end
end
