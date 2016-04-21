class CreateDistractors < ActiveRecord::Migration
  def change
    create_table :distractors do |t|
      t.sortable
      t.references :parent_term, null: false
      t.references :distractor_term, null: false

      t.timestamps null: false

      t.index :distractors, [:distractor_term_id, :parent_term_id], unique: true
    end

    add_sortable_index :distractors, scope: :parent_term_id
  end
end
