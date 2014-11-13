class Question < ActiveRecord::Base

  parsable :stimulus
  sort_domain

  attr_accessor :temp_id

  belongs_to :exercise

  has_many :stems, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :solutions, dependent: :destroy

  has_many :stylings, through: :stems

  has_many :parent_dependencies, class_name: 'QuestionDependency',
           foreign_key: :dependent_question_id, dependent: :destroy
  has_many :parent_questions, through: :parent_dependencies

  has_many :child_dependencies, class_name: 'QuestionDependency',
           foreign_key: :parent_question_id, dependent: :destroy
  has_many :dependent_questions, through: :child_dependencies

  validates :exercise, presence: true

end
