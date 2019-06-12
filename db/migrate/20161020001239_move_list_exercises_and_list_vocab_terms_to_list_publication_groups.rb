class MoveListExercisesAndListVocabTermsToListPublicationGroups < ActiveRecord::Migration[4.2]
  def up
    drop_table :list_exercises
    drop_table :list_vocab_terms
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
