class VocabTerm < ActiveRecord::Base

  EQUALITY_ASSOCIATIONS = [
    :tags,
    {
      publication: [
        :publication_group,
        :license,
        {
          derivations: :source_publication,
          authors: :user,
          copyright_holders: :user,
          editors: :user
        }
      ]
    }
  ]

  EQUALITY_EXCLUDED_FIELDS = ['id', 'uuid', 'created_at', 'updated_at', 'version',
                              'published_at', 'yanked_at', 'embargoed_until']

  # deep_clone does not iterate through hashes, so each hash must have only 1 key
  NEW_VERSION_DUPED_ASSOCIATIONS = [
    :tags,
    :vocab_distractors,
    {
      publication: [
        :derivations,
        :authors,
        :copyright_holders,
        :editors
      ]
    }
  ]

  EXERCISE_PUBLICATION_FIELDS = [
    :license, :yanked_at, :embargoed_until, :embargo_children_only, :major_change
  ]

  EXERCISE_PUBLICATION_COLLABORATORS = [
    :authors, :copyright_holders, :editors
  ]

  publishable

  has_tags

  has_many :vocab_distractors, dependent: :destroy

  has_many :exercises, dependent: :destroy, autosave: true

  has_many :list_vocab_terms, dependent: :destroy

  before_validation :build_or_update_vocab_exercises

  validates :name, :exercises, presence: true

  scope :preloaded, -> {
    preload(:tags,
            :vocab_distractors,
            publication: [
              :publication_group,
              {authors: :user},
              {copyright_holders: :user},
              {editors: :user}
            ])
  }

  def content_equals?(other_vocab_term)
    return false unless other_vocab_term.is_a? ActiveRecord::Base

    association_attributes_arguments = [EQUALITY_ASSOCIATIONS, except: EQUALITY_EXCLUDED_FIELDS,
                                                               exclude_foreign_keys: true,
                                                               transform_arrays_into_sets: true]
    attrs = association_attributes(*association_attributes_arguments)
    other_attrs = other_vocab_term.association_attributes(*association_attributes_arguments)

    attrs == other_attrs &&
    Set.new(distractor_term_numbers) == Set.new(other_vocab_term.distractor_term_numbers)
  end

  def new_version
    nv = deep_clone include: NEW_VERSION_DUPED_ASSOCIATIONS, use_dictionary: true
    nv.exercises = latest_exercises.map(&:new_version)
    nv.publication.uuid = nil
    nv.publication.version = nil
    nv.publication.published_at = nil
    nv.publication.yanked_at = nil
    nv.publication.embargoed_until = nil
    nv.publication.major_change = false
    nv
  end

  def latest_exercises
    exercises.group_by(&:number).map{ |number, exercises| exercises.max_by(&:version) }
  end

  def latest_exercise_uids
    latest_exercises.map(&:uid)
  end

  def distractor_term_numbers
    vocab_distractors.map(&:distractor_term_number)
  end

  def distractor_terms
    vocab_distractors.map(&:distractor_term)
  end

  def distractor_term_definitions
    distractor_terms.map(&:definition)
  end

  def distractors
    ([definition] + distractor_term_definitions + distractor_literals).shuffle
  end

  def before_publication
    errors.add(:base, 'must have a definition') if definition.blank?

    errors.add(:base, 'must have at least 1 distractor') \
      if distractor_literals.empty? && vocab_distractors.empty?

    return false if errors.any?

    # Publish exercises
    latest_exercises.each do |exercise|
      exercise.publication.update_attribute :published_at, published_at
    end

    true
  end

  def after_publication
    last_def = VocabTerm.joins(publication: :publication_group)
                        .where(publication: {publication_group: {number: number}})
                        .where{id != my{id}}
                        .order{publication.version.desc}
                        .limit(1).pluck(:definition)

    # Update distracted term exercises if the definition changed
    VocabTerm.joins(:vocab_distractors)
             .where(vocab_distractors: { distractor_term_number: publication.number })
             .each{ |vt| vt.build_or_update_vocab_exercises(published_at) } \
      if definition != last_def
  end

  def build_or_update_vocab_exercises(publication_time = publication.published_at)
    vocab_exercises = latest_exercises.map do |exercise|
      exercise.is_published? ? exercise.new_version : exercise
    end
    vocab_exercises = [
      Exercise.new(questions: [
        Question.new(answer_order_matters: false,  stems: [
          Stem.new(stylings: [Style::MULTIPLE_CHOICE, Style::FREE_RESPONSE].map do |style|
            Styling.new(style: style)
          end)
        ])
      ])
    ] if vocab_exercises.empty?

    vocab_exercises.each do |exercise|
      exercise.tags = tags

      ex_publication = exercise.publication
      EXERCISE_PUBLICATION_FIELDS.each do |field|
        ex_publication.send("#{field}=", publication.send(field))
      end
      EXERCISE_PUBLICATION_COLLABORATORS.each do |collab_name|
        collaborators = publication.send(collab_name).map do |collab|
          collab.class.new(publication: ex_publication, user: collab.user)
        end
        ex_publication.send("#{collab_name}=", collaborators)
      end
      ex_publication.published_at = publication_time if is_published?

      question = exercise.questions.first
      stem = question.stems.first
      # Ideally we would use separate stems here for free response vs multiple choice,
      # but we don't support that yet. Instead, we rely on tutor-js to split this stem for us.
      stem.content = "Define <strong>#{name}</strong> in your own words."
      answers = distractors.reject(&:blank?)
                           .map{ |distractor| Answer.new(question: question, content: distractor) }
      stem_answers = answers.map do |answer|
        StemAnswer.new(stem: stem, answer: answer,
                       correctness: answer.content == definition ? 1.0 : 0.0).tap do |stem_answer|
          answer.stem_answers = [stem_answer]
        end
      end
      question.answers = answers
      stem.stem_answers = stem_answers
    end

    self.exercises = (exercises + vocab_exercises).uniq
  end

end
