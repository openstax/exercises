class VocabTermTag < ApplicationRecord
  belongs_to :vocab_term
  belongs_to :tag

  validates :tag, uniqueness: { scope: :vocab_term_id }
end
