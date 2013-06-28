class CreateFillInTheBlankAnswers < ActiveRecord::Migration
  def change
    create_table :fill_in_the_blank_answers do |t|
      t.integer :question_id, :null => false
      t.text :pre_content, :null => false, :default => ''
      t.text :pre_content_cache, :null => false, :default => ''
      t.text :post_content, :null => false, :default => ''
      t.text :post_content_cache, :null => false, :default => ''
      t.string :blank_answer, :null => false, :default => ''
      t.integer :number, :null => false
      t.decimal :credit

      t.timestamps
    end

    add_index :fill_in_the_blank_answers, [:question_id, :number], :unique => true
  end
end
