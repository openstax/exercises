class AddSortPositionToQuestions < ActiveRecord::Migration
  def change
    add_sortable_column :questions, null: false
    add_sortable_index :questions, scope: :exercise_id
  end
end
