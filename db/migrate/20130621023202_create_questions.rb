class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :exercise_id
      t.text :content
      t.text :content_html
      t.integer :order
      t.decimal :credit

      t.timestamps
    end
  end
end
