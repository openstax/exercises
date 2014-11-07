class Part < ActiveRecord::Base

  parsable :stimulus
  sort_domain

  attr_accessor :temp_id

  belongs_to :exercise

  has_many :questions, dependent: :destroy
  has_many :items, through: :questions
  has_many :answers, through: :questions
  has_many :combo_choices, through: :questions

  has_many :stylings, as: :stylable, dependent: :destroy

  has_many :parent_dependencies, class_name: 'PartDependency',
           foreign_key: :dependent_part_id, dependent: :destroy
  has_many :parent_parts, through: :parent_dependencies

  has_many :child_dependencies, class_name: 'PartDependency',
           foreign_key: :parent_part_id, dependent: :destroy
  has_many :dependent_parts, through: :child_dependencies

  validates :exercise, presence: true

  delegate_access_control_to :exercise

end
