class VocabTermTag < ApplicationRecord
  belongs_to :vocab_term
  belongs_to :tag

  validates :vocab_term, presence: true
  validates :tag, presence: true, uniqueness: { scope: :vocab_term_id }
end
