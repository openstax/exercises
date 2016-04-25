class VocabTerm < ActiveRecord::Base

  # deep_clone does not iterate through hashes, so each hash must have only 1 key
  NEW_VERSION_DUPED_ASSOCIATIONS = [
    :tags,
    :vocab_distractors,
    {
      publication: [
        :authors,
        :copyright_holders,
        :editors
      ]
    }
  ]

  EXERCISE_PUBLICATION_FIELDS = [
    :license, :published_at, :yanked_at, :embargoed_until, :embargo_children_only, :major_change
  ]

  EXERCISE_PUBLICATION_COLLABORATORS = [
    :authors, :copyright_holders, :editors
  ]

  publishable

  has_tags

  has_many :vocab_distractors, dependent: :destroy
  has_many :distractor_terms, through: :vocab_distractors
  has_many :vocab_distracteds, class_name: 'VocabDistractor', foreign_key: 'distractor_term_id',
                               dependent: :destroy, inverse_of: :distractor_term
  has_many :distracted_terms, through: :vocab_distracteds, source: :vocab_term

  has_many :exercises, dependent: :destroy, autosave: true

  before_validation :build_or_update_vocab_exercises

  validates :name, presence: true
  validates :definition, presence: true
  validates :exercises, presence: true

  scope :preloaded, -> {
    preload(:tags,
            publication: [authors: :user, copyright_holders: :user, editors: :user],
            vocab_distractors: :distractor_term)
  }

  scope :visible_for, ->(user) {
    user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
    next none if !user.is_a?(User) || user.is_anonymous?
    next self if user.administrator
    user_id = user.id

    joins{publication.authors.outer}
      .joins{publication.copyright_holders.outer}
      .joins{publication.editors.outer}
      .where{ (authors.user_id == user_id) | \
              (copyright_holders.user_id == user_id) | \
              (editors.user_id == user_id) }
  }

  def new_version
    nv = deep_clone include: NEW_VERSION_DUPED_ASSOCIATIONS, use_dictionary: true
    nv.exercises = exercises.map(&:new_version)
    nv.publication.version = nv.publication.version + 1
    nv.publication.published_at = nil
    nv.publication.yanked_at = nil
    nv.publication.embargoed_until = nil
    nv.publication.major_change = false
    nv
  end

  def exercise_ids
    exercises.pluck(:id)
  end

  def publication_validation
    return true if vocab_distractors.any? || distractor_literals.any?
    errors.add(:base, 'must have at least 1 distractor')
    false
  end

  protected

  def build_or_update_vocab_exercises
    return if definition.nil?

    vocab_exercises = exercises.any? ? exercises : [
      Exercise.new(questions: [
        Question.new(answer_order_matters: false,  stems: [
          Stem.new(stylings: [Style::MULTIPLE_CHOICE, Style::FREE_RESPONSE].map do |style|
            Styling.new(style: style)
          end)
        ])
      ])
    ]

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

      question = exercise.questions.first
      stem = question.stems.first
      stem.content = "#{name}?"
      distractors = (([self] + distractor_terms).map(&:definition) + distractor_literals).shuffle
      answers = distractors.map{ |distractor| Answer.new(question: question, content: distractor) }
      stem_answers = answers.map do |answer|
        StemAnswer.new(stem: stem, answer: answer,
                       correctness: answer.content == definition ? 1.0 : 0.0).tap do |stem_answer|
          answer.stem_answers = [stem_answer]
        end
      end
      question.answers = answers
      stem.stem_answers = stem_answers
    end

    self.exercises = vocab_exercises
  end

end
