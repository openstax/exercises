class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :question, null: false
      t.references :item, null: false
      t.decimal :correctness, null: false, precision: 3, scale: 2, default: 0
      t.text :content, null: false
      t.text :feedback

      t.timestamps
    end

    add_index :answers, [:question_id, :correctness]
    add_index :answers, [:item_id, :correctness]
  end
end
