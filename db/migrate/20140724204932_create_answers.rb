class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.sortable
      t.references :question, null: false
      t.references :item
      t.decimal :correctness, null: false, precision: 3, scale: 2, default: 0
      t.text :content
      t.string :regex
      t.float :value
      t.float :tolerance
      t.text :feedback

      t.timestamps
    end

    add_sortable_index :answers, :question_id
    add_index :answers, :item_id
    add_index :answers, :correctness
  end
end
