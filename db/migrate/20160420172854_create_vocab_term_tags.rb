class CreateVocabTermTags < ActiveRecord::Migration[4.2]
  def change
    create_table :vocab_term_tags do |t|
      t.references :vocab_term, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :tag, index: true, foreign_key: { on_update: :cascade,
                                                     on_delete: :cascade }

      t.timestamps null: false

      t.index [:vocab_term_id, :tag_id], unique: true
    end
  end
end
