class CreateFreeResponses < ActiveRecord::Migration
  def change
    create_table :free_responses do |t|
      t.integer :question_id
      t.text :content
      t.text :content_html
      t.text :free_response
      t.integer :order
      t.decimal :credit

      t.timestamps
    end
  end
end
