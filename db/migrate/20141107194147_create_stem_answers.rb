class CreateStemAnswers < ActiveRecord::Migration[4.2]
  def change
    create_table :stem_answers do |t|
      t.references :stem, null: false
      t.references :answer, null: false
      t.decimal :correctness, null: false, precision: 3, scale: 2, default: 0
      t.text :feedback

      t.timestamps null: false
    end

    add_index :stem_answers, [:answer_id, :stem_id], unique: true
    add_index :stem_answers, [:stem_id, :correctness]
  end
end
