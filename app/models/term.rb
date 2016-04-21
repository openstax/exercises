class Term < ActiveRecord::Base
  publishable

  has_tags

  has_many :distractors, foreign_key: 'parent_term_id',
                         dependent: :destroy, inverse_of: :parent_term
  has_many :distractor_terms, through: :distractors
  has_many :distracteds, class_name: 'Distractor', foreign_key: 'distractor_term_id',
                         dependent: :destroy, inverse_of: :distractor_term
  has_many :distracted_terms, through: :distracteds, source: :parent_term

  has_many :exercises, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true, uniqueness: { scope: :name }
end
