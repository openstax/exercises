class CreateTrueOrFalseAnswers < ActiveRecord::Migration
  def change
    create_table :true_or_false_answers do |t|
      t.integer :question_id, :null => false
      t.text :content, :null => false, :default => ''
      t.text :content_cache, :null => false, :default => ''
      t.boolean :is_true, :null => false, :default => false
      t.integer :number, :null => false
      t.decimal :credit

      t.timestamps
    end

    add_index :true_or_false_answers, [:question_id, :number], :unique => true
  end
end
