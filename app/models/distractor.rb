class Distractor < ActiveRecord::Base
  sortable_belongs_to :parent_term, class_name: 'Term', inverse_of: :distractors
  belongs_to :distractor_term, class_name: 'Term', inverse_of: :distracteds

  validates :parent_term, presence: true
  validates :distractor_term, presence: true, uniqueness: { scope: :parent_term_id }
end
