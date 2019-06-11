class AddSortPositionToAnswers < ActiveRecord::Migration[4.2]
  def change
    add_sortable_column :answers, null: false
    add_sortable_index :answers, scope: :question_id
  end
end
