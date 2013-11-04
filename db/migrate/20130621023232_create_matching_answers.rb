class CreateMatchingAnswers < ActiveRecord::Migration
  def change
    create_table :matching_answers do |t|
      t.content [:left_content, :right_content]
      t.credit
      t.sortable
      t.belongs_to :question, null: false

      t.timestamps
    end

    add_sortable_index :matching_answers, :question_id
  end
end
