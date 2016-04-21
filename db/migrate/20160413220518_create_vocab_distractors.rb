class CreateVocabDistractors < ActiveRecord::Migration
  def change
    create_table :vocab_distractors do |t|
      t.sortable
      t.references :vocab_term, null: false
      t.references :distractor_term, null: false

      t.timestamps null: false

      t.index [:distractor_term_id, :vocab_term_id], unique: true
    end

    add_sortable_index :vocab_distractors, scope: :vocab_term_id
  end
end
