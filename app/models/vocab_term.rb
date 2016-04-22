class VocabTerm < ActiveRecord::Base
  publishable

  has_tags

  has_many :vocab_distractors, dependent: :destroy
  has_many :distractor_terms, through: :vocab_distractors
  has_many :vocab_distracteds, class_name: 'VocabDistractor', foreign_key: 'distractor_term_id',
                               dependent: :destroy, inverse_of: :distractor_term
  has_many :distracted_terms, through: :vocab_distracteds, source: :vocab_term

  has_many :exercises, dependent: :destroy

  validates :name, presence: true
  validates :definition, presence: true, uniqueness: { scope: :name }

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

  def exercise_ids
    exercises.pluck(:id)
  end

  def publication_validation
    return true unless distractor_terms.empty? && distractor_literals.empty?
    errors.add(:base, 'must have at least 1 distractor')
    false
  end

end
