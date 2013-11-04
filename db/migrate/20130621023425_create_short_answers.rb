class CreateShortAnswers < ActiveRecord::Migration
  def change
    create_table :short_answers do |t|
      t.content
      t.credit
      t.sortable
      t.belongs_to :question, null: false
      t.string :short_answer, null: false, default: ''

      t.timestamps
    end

    add_sortable_index :short_answers, :question_id
  end
end
