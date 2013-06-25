class CreateMultipleChoiceAnswers < ActiveRecord::Migration
  def change
    create_table :multiple_choice_answers do |t|
      t.integer :question_id
      t.string :content
      t.string :content_html
      t.integer :number
      t.decimal :credit

      t.timestamps
    end

    add_index :multiple_choice_answers, [:question_id, :number], :unique => true
  end
end
