class CreateTrueOrFalseAnswers < ActiveRecord::Migration
  def change
    create_table :true_or_false_answers do |t|
      t.integer :question_id
      t.text :content
      t.text :content_html
      t.boolean :is_true
      t.integer :order
      t.decimal :credit

      t.timestamps
    end
  end
end
