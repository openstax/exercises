class CreateDistractorTerms < ActiveRecord::Migration
  def change
    create_table :distractor_terms do |t|
      t.sortable
      t.references :term, null: false
      t.references :distractor_term, null: false

      t.timestamps null: false
    end

    add_sortable_index :distractor_terms, scope: :term_id
  end
end
