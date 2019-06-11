class AddVocabTermIdToExercises < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :vocab_term_id, :integer

    add_index :exercises, :vocab_term_id
  end
end
