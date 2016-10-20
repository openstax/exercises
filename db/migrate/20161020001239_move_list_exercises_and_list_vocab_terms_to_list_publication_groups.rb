class MoveListExercisesAndListVocabTermsToListPublicationGroups < ActiveRecord::Migration
  def up
    exercise_id_list_id_pairs = \
      ActiveRecord::Base.connection.execute('SELECT list_id, exercise_id FROM list_exercises;')

    vocab_term_id_list_id_pairs = \
      ActiveRecord::Base.connection.execute('SELECT list_id, vocab_term_id FROM list_vocab_terms;')

    all_list_ids = exercise_id_list_id_pairs.map{ |hash| hash['list_id'] } +
                   vocab_term_id_list_id_pairs.map{ |hash| hash['list_id'] }

    list_by_list_id = List.where(id: all_list_ids).index_by(&:id)

    all_exercise_ids = exercise_id_list_id_pairs.map{ |hash| hash['exercise_id'] }

    publication_group_by_exercise_id = {}
    PublicationGroup.joins(:publications)
                    .where(publishable_type: 'Exercise',
                           publications: { publishable_id: all_exercise_ids })
                    .select([:id, Publication.arel_table[:publishable_id]])
                    .each do |pg|
      publication_group_by_exercise_id[pg.publishable_id] = pg
    end

    exercise_id_list_id_pairs.each do |exercise_id, list_id|
      list = list_by_list_id[list_id]
      pg = publication_group_by_exercise_id[exercise_id]
      # Using #create instead of #create! so we don't error out on duplicates
      ListPublicationGroup.create(list: list, publication_group: pg)
    end

    all_vocab_term_ids = vocab_term_id_list_id_pairs.map{ |hash| hash['vocab_term_id'] }

    publication_group_by_vocab_term_id = {}
    PublicationGroup.joins(:publications)
                    .where(publishable_type: 'VocabTerm',
                           publications: { publishable_id: all_vocab_term_ids })
                    .select([:id, Publication.arel_table[:publishable_id]])
                    .each do |pg|
      publication_group_by_vocab_term_id[pg.publishable_id] = pg
    end

    vocab_term_id_list_id_pairs.each do |vocab_term_id, list_id|
      list = list_by_list_id[list_id]
      pg = publication_group_by_exercise_id[vocab_term_id]
      # Using #create instead of #create! so we don't error out on duplicates
      ListPublicationGroup.create(list: list, publication_group: pg)
    end

    drop_table :list_exercises
    drop_table :list_vocab_terms
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
