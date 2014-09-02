class PartSupport < ActiveRecord::Base

  sortable :supported_part

  belongs_to :supporting_part, class_name: 'Part', inverse_of: :child_supports
  belongs_to :supported_part, class_name: 'Part', inverse_of: :parent_supports

  validates :supporting_part, presence: true
  validates :supported_part, presence: true, uniqueness: { scope: :supporting_part_id }

  validate :same_exercise

  delegate_access_control_to :supported_part

  protected

  def same_exercise
    return if supporting_part.exercise_id == supported_part.exercise_id
    error.add(:base, 'must refer to a single exercise')
    false
  end

end
