class CreateVocabTerms < ActiveRecord::Migration
  def change
    create_table :vocab_terms do |t|
      t.string :name, null: false
      t.string :definition, null: false, index: true
      t.string :distractor_literals, array: true, null: false, default: []

      t.timestamps null: false

      t.index [:name, :definition]
    end
  end
end
