class CreateListVocabTerms < ActiveRecord::Migration[4.2]
  def change
    create_table :list_vocab_terms do |t|
      t.sortable
      t.references :list, null: false, foreign_key: true
      t.references :vocab_term, null: false, foreign_key: true

      t.timestamps null: false

      t.index [:vocab_term_id, :list_id], unique: true
    end

    add_sortable_index :list_vocab_terms, scope: :list_id
  end
end
