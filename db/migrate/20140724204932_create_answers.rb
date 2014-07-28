class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.sortable
      t.references :question, null: false
      t.decimal :correctness, null: false, precision: 5, scale: 2, default: 0
      t.text :content, null: false

      t.timestamps
    end

    add_sortable_index :answers, :question_id
  end
end
