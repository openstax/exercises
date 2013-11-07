class CreateTrueOrFalseAnswers < ActiveRecord::Migration
  def change
    create_table :true_or_false_answers do |t|
      t.content
      t.credit
      t.sortable
      t.belongs_to :question, null: false
      t.boolean :is_true, null: false, default: false

      t.timestamps
    end

    add_sortable_index :true_or_false_answers, :question_id
  end
end
