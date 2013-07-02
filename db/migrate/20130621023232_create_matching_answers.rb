class CreateMatchingAnswers < ActiveRecord::Migration
  def change
    create_table :matching_answers do |t|
      t.string :content, :null => false, :default => ''
      t.string :content_cache, :null => false, :default => ''
      t.integer :number, :null => false
      t.integer :question_id, :null => false
      t.integer :match_number, :null => false
      t.boolean :right_column, :null => false, :default => false
      t.decimal :credit

      t.timestamps
    end

    add_index :matching_answers, [:question_id, :number], :unique => true
  end
end
