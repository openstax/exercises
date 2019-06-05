class CreateVocabDistractors < ActiveRecord::Migration[4.2]
  def change
    create_table :vocab_distractors do |t|
      t.references :vocab_term, null: false
      t.integer :distractor_term_number, null: false, index: true

      t.timestamps null: false

      t.index [:vocab_term_id, :distractor_term_number],
              unique: true, name: 'index_vocab_distractors_on_v_t_id_and_d_t_number'
    end
  end
end
