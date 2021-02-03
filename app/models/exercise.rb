class Exercise < ApplicationRecord

  EQUALITY_ASSOCIATIONS = [
    :images,
    :logic,
    :tags,
    publication: [
      :publication_group,
      :license,
      derivations: :source_publication,
      authors: :user,
      copyright_holders: :user
    ],
    questions: [
      :collaborator_solutions,
      :hints,
      answers: :stem_answers,
      stems: [
        :stylings,
        :combo_choices
      ]
    ]
  ]

  EQUALITY_EXCLUDED_FIELDS = ['id', 'uuid', 'created_at', 'updated_at', 'version',
                              'published_at', 'yanked_at', 'embargoed_until']

  # deep_clone does not iterate through hashes, so each hash must have only 1 key
  NEW_VERSION_DUPED_ASSOCIATIONS = [
    :images,
    :logic,
    :tags,
    {
      publication: [
        :derivations,
        :authors,
        :copyright_holders
      ]
    },
    {
      questions: [
        :hints,
        :answers,
        {
          collaborator_solutions: [
            :images,
            :logic,
            :stylings
          ]
        },
        {
          stems: [
            :stylings,
            :combo_choices,
            stem_answers: :answer
          ]
        }
      ]
    }
  ]

  CACHEABLE_ASSOCIATIONS = [
    :images,
    :logic,
    :tags,
    publication: [
      :derivations,
      authors: { user: :account },
      copyright_holders: { user: :account }
    ],
    questions: [
      :hints,
      :collaborator_solutions,
      :community_solutions,
      answers: :stem_answers,
      stems: [ :stylings, :combo_choices ]
    ]
  ]

  UNCACHEABLE_ASSOCIATIONS = [
    publication: [
      publication_group: :publications,
      authors: { user: :delegations_as_delegator },
      copyright_holders: { user: :delegations_as_delegator }
    ]
  ]

  acts_as_votable
  user_html :stimulus
  publishable
  has_attachments
  has_logic :javascript, :latex
  has_tags

  sortable_has_many :questions, dependent: :destroy, autosave: true, inverse_of: :exercise

  belongs_to :vocab_term, touch: true, optional: true

  scope :can_release_to_a15k, -> { where(release_to_a15k: true) }
  scope :not_released_to_a15k, -> { where(a15k_identifier: nil) }

  def content_equals?(other_exercise)
    return false unless other_exercise.is_a? ActiveRecord::Base

    association_attributes_arguments = [EQUALITY_ASSOCIATIONS, except: EQUALITY_EXCLUDED_FIELDS,
                                                               exclude_foreign_keys: true,
                                                               transform_arrays_into_sets: true]
    attrs = association_attributes(*association_attributes_arguments)
    other_attrs = other_exercise.association_attributes(*association_attributes_arguments)

    attrs == other_attrs
  end

  def new_version
    nv = deep_clone include: NEW_VERSION_DUPED_ASSOCIATIONS, use_dictionary: true
    nv.publication.uuid = nil
    nv.publication.version = nil
    nv.publication.published_at = nil
    nv.publication.yanked_at = nil
    nv.publication.embargoed_until = nil
    nv.publication.major_change = false
    nv
  end

  def can_view_solutions?(user)
    return false if user.nil?          # User not given
    return true if new_record?         # Exercise being created

    user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)

    # Modify the line below if we implement delegating to apps
    return true if user.nil?           # Application user
    return false if user.is_anonymous? # Anonymous user

    has_read_permission?(user)         # Regular user
  end

  def is_vocab?
    vocab_term_id.present?
  end

  def before_publication
    # Check that all stems have either no answers (free response) or at least one correct answer
    questions.each do |question|
      question.stems.each do |stem|
        next if stem.stem_answers.empty? || stem.stem_answers.any?(&:is_correct?)
        errors.add(:base, 'has a question with only incorrect answers')
        throw(:abort)
      end
    end
  end

  protected

  def has_questions
    return unless questions.first.nil?
    errors.add(:questions, "can't be blank")
    throw(:abort)
  end

end
