class Part < ActiveRecord::Base

  sortable :exercise

  belongs_to :exercise, inverse_of: :parts

  has_many :questions, dependent: :destroy, inverse_of: :part
  has_many :items, through: :questions
  has_many :item_answers, through: :items, source: :answers
  has_many :question_answers, through: :questions, source: :answers
  has_many :combo_choices, through: :questions

  has_many :child_dependencies, class_name: 'PartDependency',
           dependent: :destroy, inverse_of: :parent_part
  has_many :parent_dependencies, class_name: 'PartDependency',
           dependent: :destroy, inverse_of: :dependent_part

  has_many :child_supports, class_name: 'PartSupport',
           dependent: :destroy, inverse_of: :supporting_part
  has_many :parent_supports, class_name: 'PartSupport',
           dependent: :destroy, inverse_of: :supported_part

  validates :exercise, presence: true

  delegate_access_control_to :exercise

end
