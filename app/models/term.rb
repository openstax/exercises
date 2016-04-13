class Term < ActiveRecord::Base
  has_many :distractors, foreign_key: 'parent_term_id',
                         dependent: :destroy, inverse_of: :parent_term
  has_many :distracteds, class_name: 'Distractor', foreign_key: 'distractor_term_id',
                         dependent: :destroy, inverse_of: :distractor_term

  has_many :exercises, dependent: :destroy
end
