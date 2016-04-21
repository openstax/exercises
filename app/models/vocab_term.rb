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
end
