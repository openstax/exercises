class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.sortable
      t.references :question, null: false
      t.text :content, null: false
      t.decimal :credit, null: false, default: 0

      t.timestamps
    end

    add_sortable_index :answers, :question_id
  end
end
