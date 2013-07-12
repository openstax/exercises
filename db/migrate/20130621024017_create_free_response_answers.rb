class CreateFreeResponseAnswers < ActiveRecord::Migration
  def change
    create_table :free_response_answers do |t|
      t.text :content, :null => false, :default => ''
      t.text :content_cache, :null => false, :default => ''
      t.integer :position, :null => false
      t.integer :question_id, :null => false
      t.text :free_response, :null => false, :default => ''
      t.boolean :can_be_sketched, :null => false, :default => false
      t.integer :credit

      t.timestamps
    end

    add_index :free_response_answers, [:question_id, :position], :unique => true
  end
end
