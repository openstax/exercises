class CreateMultipleChoiceAnswers < ActiveRecord::Migration
  def change
    create_table :multiple_choice_answers do |t|
      t.integer :question_id
      t.string :content
      t.string :content_html
      t.integer :order
      t.decimal :credit

      t.timestamps
    end
  end
end
