class Question < ActiveRecord::Base

  user_html :stimulus

  attr_accessor :temp_id

  belongs_to :exercise

  has_many :stems, dependent: :destroy

  sortable_has_many :answers, dependent: :destroy, inverse_of: :question

  has_many :collaborator_solutions, dependent: :destroy
  has_many :community_solutions, dependent: :destroy

  sortable_has_many :hints, dependent: :destroy, inverse_of: :question

  has_many :parent_dependencies, class_name: 'QuestionDependency',
           foreign_key: :dependent_question_id, dependent: :destroy,
           inverse_of: :dependent_question

  has_many :child_dependencies, class_name: 'QuestionDependency',
           foreign_key: :parent_question_id, dependent: :destroy,
           inverse_of: :parent_question

  validates :exercise, presence: true

end
