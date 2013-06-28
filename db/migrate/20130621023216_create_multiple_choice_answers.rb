class CreateMultipleChoiceAnswers < ActiveRecord::Migration
  def change
    create_table :multiple_choice_answers do |t|
      t.integer :question_id, :null => false
      t.string :content, :null => false, :default => ''
      t.string :content_cache, :null => false, :default => ''
      t.integer :number, :null => false
      t.decimal :credit

      t.timestamps
    end

    add_index :multiple_choice_answers, [:question_id, :number], :unique => true
  end
end
