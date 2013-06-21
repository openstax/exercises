class CreateMatchingAnswers < ActiveRecord::Migration
  def change
    create_table :matching_answers do |t|
      t.integer :question_id
      t.string :content
      t.string :content_html
      t.integer :match_number
      t.boolean :right_column
      t.integer :order
      t.decimal :credit

      t.timestamps
    end
  end
end
