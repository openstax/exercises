class CreateFillInTheBlankAnswers < ActiveRecord::Migration
  def change
    create_table :fill_in_the_blank_answers do |t|
      t.integer :question_id
      t.text :pre_content
      t.text :pre_content_html
      t.text :post_content
      t.text :post_content_html
      t.string :blank_answer
      t.integer :order
      t.decimal :credit

      t.timestamps
    end
  end
end
