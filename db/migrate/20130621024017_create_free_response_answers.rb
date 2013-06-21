class CreateFreeResponseAnswers < ActiveRecord::Migration
  def change
    create_table :free_response_answers do |t|
      t.integer :question_id
      t.text :content
      t.text :content_html
      t.text :free_response
      t.boolean :can_be_sketched
      t.integer :order
      t.decimal :credit

      t.timestamps
    end
  end
end
