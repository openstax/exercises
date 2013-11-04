class CreateFillInTheBlankAnswers < ActiveRecord::Migration
  def change
    create_table :fill_in_the_blank_answers do |t|
      t.content [:pre_content, :post_content]
      t.credit
      t.sortable
      t.belongs_to :question, null: false
      t.string :blank_answer, null: false, default: ''

      t.timestamps
    end

    add_sortable_index :fill_in_the_blank_answers, :question_id
  end
end
