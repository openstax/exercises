class RenameDistractorTermNumberToDistractorPublicationGroupId < ActiveRecord::Migration[4.2]
  def up
    add_column :vocab_distractors, :distractor_publication_group_id, :integer

    change_column_null :vocab_distractors, :distractor_publication_group_id, false
    add_index :vocab_distractors, :distractor_publication_group_id
    add_index :vocab_distractors, [:vocab_term_id, :distractor_publication_group_id],
              name: "index_vocab_distractors_on_v_t_id_and_d_p_g_id", unique: true

    remove_index :vocab_distractors, :distractor_term_number
    remove_index :vocab_distractors, name: "index_vocab_distractors_on_v_t_id_and_d_t_number"
    remove_column :vocab_distractors, :distractor_term_number
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
