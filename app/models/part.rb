class Part < ActiveRecord::Base

  sortable :exercise_id

  belongs_to :exercise, inverse_of: :parts

  has_many :questions, dependent: :destroy, inverse_of: :part
  has_many :solutions, dependent: :destroy, inverse_of: :part

  validates :exercise, presence: true

  delegate_access_control_to :exercise, include_sort: true

end
