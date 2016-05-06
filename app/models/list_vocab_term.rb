class ListVocabTerm < ActiveRecord::Base

  sortable_belongs_to :list, inverse_of: :list_vocab_terms
  belongs_to :vocab_term

  validates :list, presence: true
  validates :vocab_term, presence: true, uniqueness: { scope: :list_id }

end
