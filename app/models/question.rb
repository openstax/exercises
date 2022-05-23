class Question < ApplicationRecord
  attr_accessor :temp_id

  user_html :stimulus

  sortable_belongs_to :exercise, touch: true, inverse_of: :questions

  has_many :stems, dependent: :destroy

  sortable_has_many :answers, dependent: :destroy, inverse_of: :question, autosave: true

  has_many :collaborator_solutions, dependent: :destroy
  has_many :community_solutions

  sortable_has_many :hints, dependent: :destroy, inverse_of: :question

  has_many :parent_dependencies, class_name: 'QuestionDependency',
           foreign_key: :dependent_question_id, dependent: :destroy,
           inverse_of: :dependent_question

  has_many :child_dependencies, class_name: 'QuestionDependency',
           foreign_key: :parent_question_id, dependent: :destroy,
           inverse_of: :parent_question

  def flattened_content
    ([ stimulus ] + stems.map(&:flattened_content)).join("\n")
  end
end
