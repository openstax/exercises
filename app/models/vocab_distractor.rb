class VocabDistractor < ActiveRecord::Base
  sortable_belongs_to :vocab_term, inverse_of: :vocab_distractors
  belongs_to :distractor_term, class_name: 'VocabTerm', inverse_of: :vocab_distracteds

  validates :vocab_term, presence: true
  validates :distractor_term, presence: true, uniqueness: { scope: :vocab_term_id }
end
