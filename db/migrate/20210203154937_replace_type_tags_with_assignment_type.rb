class ReplaceTypeTagsWithAssignmentType < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    new_hw_tag = Tag.find_or_create_by name: 'assignment-type:homework'
    old_hw_tag_ids = Tag.where(name: 'type:practice').pluck(:id)

    exercise_ids = ExerciseTag.where(tag_id: old_hw_tag_ids).distinct.pluck(:exercise_id)
    Exercise.where(id: exercise_ids)
            .latest
            .preload(:exercise_tags, :publication)
            .find_each(batch_size: 100) do |exercise|
      Exercise.transaction do
        if exercise.is_published?
          exercise = exercise.new_version
          exercise.save!
        end
        exercise.exercise_tags = exercise.exercise_tags.reject do |et|
          old_hw_tag_ids.include? et.tag_id
        end
        exercise.exercise_tags << ExerciseTag.new(exercise: exercise, tag: new_hw_tag)
        exercise.publication.publish.save!
      end
    end

    vocab_term_ids = VocabTermTag.where(tag_id: old_hw_tag_ids).distinct.pluck(:vocab_term_id)
    VocabTerm.where(id: vocab_term_ids)
             .latest
             .preload(:vocab_term_tags, :publication)
             .find_each(batch_size: 100) do |vocab_term|
      VocabTerm.transaction do
        if vocab_term.is_published?
          vocab_term = vocab_term.new_version
          vocab_term.save!
        end
        vocab_term.vocab_term_tags = vocab_term.vocab_term_tags.reject do |vtt|
          old_hw_tag_ids.include? vtt.tag_id
        end
        vocab_term.vocab_term_tags << VocabTermTag.new(vocab_term: vocab_term, tag: new_hw_tag)
        vocab_term.publication.publish.save!
      end
    end

    new_rd_tag = Tag.find_or_create_by name: 'assignment-type:reading'
    old_rd_tag_ids = Tag.where(
      name: [ 'type:conceptual', 'type:recall', 'type:conceptual-or-recall' ]
    ).pluck(:id)

    exercise_ids = ExerciseTag.where(tag_id: old_rd_tag_ids).distinct.pluck(:exercise_id)
    Exercise.where(id: exercise_ids)
            .latest
            .preload(:exercise_tags)
            .find_each(batch_size: 100) do |exercise|
      Exercise.transaction do
        if exercise.is_published?
          exercise = exercise.new_version
          exercise.save!
        end
        exercise.exercise_tags = exercise.exercise_tags.reject do |et|
          old_rd_tag_ids.include? et.tag_id
        end
        exercise.exercise_tags << ExerciseTag.new(exercise: exercise, tag: new_rd_tag)
        exercise.publication.publish.save!
      end
    end

    vocab_term_ids = VocabTermTag.where(tag_id: old_rd_tag_ids).distinct.pluck(:vocab_term_id)
    VocabTerm.where(id: vocab_term_ids)
             .latest
             .preload(:vocab_term_tags)
             .find_each(batch_size: 100) do |vocab_term|
      VocabTerm.transaction do
        if vocab_term.is_published?
          vocab_term = vocab_term.new_version
          vocab_term.save!
        end
        vocab_term.vocab_term_tags = vocab_term.vocab_term_tags.reject do |vtt|
          old_rd_tag_ids.include? vtt.tag_id
        end
        vocab_term.vocab_term_tags << VocabTermTag.new(vocab_term: vocab_term, tag: new_rd_tag)
        vocab_term.publication.publish.save!
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
