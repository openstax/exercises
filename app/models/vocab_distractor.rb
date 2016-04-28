class VocabDistractor < ActiveRecord::Base
  belongs_to :vocab_term, inverse_of: :vocab_distractors
  belongs_to :distractor_publication, -> { where(publishable_type: 'VocabTerm').limit(1) },
                                      class_name: 'Publication',
                                      primary_key: 'number',
                                      foreign_key: 'distractor_term_number'
  has_one :distractor_term, through: :distractor_publication,
                            class_name: 'VocabTerm',
                            source: :publishable,
                            source_type: 'VocabTerm'

  validates :vocab_term, presence: true
  validates :distractor_publication, presence: true, uniqueness: { scope: :vocab_term_id }

  delegate :tags, :uid, :version, :published_at, :license, :editors, :authors,
           :copyright_holders, :derivations, :name, :definition, to: :distractor_term

  def number
    distractor_term_number
  end

  def distractor_term=(new_term)
    self.distractor_publication = new_term.publication
  end
end
