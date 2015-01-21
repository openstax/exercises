class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question, null: false
      t.text :content, null: false

      t.timestamps null: false
    end

    add_index :answers, :question_id
  end
end
