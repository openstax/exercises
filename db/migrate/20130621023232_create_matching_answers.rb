class CreateMatchingAnswers < ActiveRecord::Migration
  def change
    create_table :matching_answers do |t|
      t.string :left_content, :null => false, :default => ''
      t.string :left_content_html, :null => false, :default => ''
      t.string :right_content, :null => false, :default => ''
      t.string :right_content_html, :null => false, :default => ''
      t.integer :position, :null => false
      t.integer :question_id, :null => false
      t.integer :credit

      t.timestamps
    end

    add_index :matching_answers, [:question_id, :position], :unique => true
  end
end
