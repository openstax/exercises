class Question < ActiveRecord::Base

  sort_domain

  attr_accessor :temp_id

  belongs_to :part, inverse_of: :questions
  has_one :exercise, through: :part

  has_many :formattings, as: :formattable, dependent: :destroy

  has_many :solutions, dependent: :destroy, inverse_of: :question

  has_many :items, dependent: :destroy, inverse_of: :question
  has_many :answers, dependent: :destroy, inverse_of: :question
  has_many :combo_choices, dependent: :destroy, inverse_of: :question

  has_many :parent_dependencies, class_name: 'QuestionDependency',
           foreign_key: :dependent_question_id,
           dependent: :destroy, inverse_of: :dependent_question
  has_many :parent_questions, through: :parent_dependencies

  has_many :child_dependencies, class_name: 'QuestionDependency',
           foreign_key: :parent_question_id,
           dependent: :destroy, inverse_of: :parent_question
  has_many :dependent_questions, through: :child_dependencies

  validates :part, presence: true

  delegate_access_control_to :part

end
