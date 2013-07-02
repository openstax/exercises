class CreateShortAnswers < ActiveRecord::Migration
  def change
    create_table :short_answers do |t|
      t.text :content, :null => false, :default => ''
      t.text :content_cache, :null => false, :default => ''
      t.integer :number, :null => false
      t.integer :question_id, :null => false
      t.string :short_answer, :null => false, :default => ''
      t.decimal :credit

      t.timestamps
    end

    add_index :short_answers, [:question_id, :number], :unique => true
  end
end
