class CreateMultipleChoiceAnswers < ActiveRecord::Migration
  def change
    create_table :multiple_choice_answers do |t|
      t.string :content, :null => false, :default => ''
      t.string :content_html, :null => false, :default => ''
      t.integer :position, :null => false
      t.integer :question_id, :null => false
      t.boolean :is_always_last, :null => false, :default => false
      t.integer :credit

      t.timestamps
    end

    add_index :multiple_choice_answers, [:question_id, :position], :unique => true
  end
end
