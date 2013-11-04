class CreateFreeResponseAnswers < ActiveRecord::Migration
  def change
    create_table :free_response_answers do |t|
      t.content [:content, :free_response]
      t.credit
      t.sortable
      t.belongs_to :question, null: false
      t.boolean :can_be_sketched, null: false, default: false

      t.timestamps
    end

    add_sortable_index :free_response_answers, :question_id
  end
end
