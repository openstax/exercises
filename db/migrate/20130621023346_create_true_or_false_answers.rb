class CreateTrueOrFalseAnswers < ActiveRecord::Migration
  def change
    create_table :true_or_false_answers do |t|
      t.integer :question_id
      t.text :content
      t.text :content_html
      t.boolean :is_true
      t.integer :number
      t.decimal :credit

      t.timestamps
    end

    add_index :true_or_false_answers, [:question_id, :number], :unique => true
  end
end
