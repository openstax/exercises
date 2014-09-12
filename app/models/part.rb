class Part < ActiveRecord::Base

  sort_domain

  belongs_to :exercise, inverse_of: :parts

  has_many :questions, dependent: :destroy, inverse_of: :part
  has_many :items, through: :questions
  has_many :item_answers, through: :items, source: :answers
  has_many :question_answers, through: :questions, source: :answers
  has_many :combo_choices, through: :questions

  has_many :parent_dependencies, class_name: 'PartDependency',
           dependent: :destroy, inverse_of: :dependent_part
  has_many :parent_parts, through: :parent_dependencies

  has_many :child_dependencies, class_name: 'PartDependency',
           dependent: :destroy, inverse_of: :parent_part
  has_many :dependent_parts, through: :child_dependencies

  validates :exercise, presence: true

  delegate_access_control_to :exercise

end
