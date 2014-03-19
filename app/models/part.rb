class Part < ActiveRecord::Base
  sortable :exercise_id

  belongs_to :exercise, inverse_of: :parts
  belongs_to :background, class_name: 'Content', dependent: :destroy
  has_many :solutions, :dependent => :destroy, :inverse_of => :part
  has_many :questions, dependent: :destroy, inverse_of: :part

  attr_accessible :credit, :background_attributes

  accepts_nested_attributes_for :background

  validate :exercise_id, presence: true

  delegate_access_control to: :exercise,
                          include_sort: true
end
