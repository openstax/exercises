class CreateShortAnswers < ActiveRecord::Migration
  def change
    create_table :short_answers do |t|
      t.text :content, :null => false, :default => ''
      t.text :content_cache, :null => false, :default => ''
      t.integer :position, :null => false
      t.integer :question_id, :null => false
      t.string :short_answer, :null => false, :default => ''
      t.integer :credit

      t.timestamps
    end

    add_index :short_answers, [:question_id, :position], :unique => true
  end
end
