class PartSupport < ActiveRecord::Base

  belongs_to :supporting_part, class_name: 'Part', inverse_of: :child_supports
  belongs_to :supported_part, class_name: 'Part', inverse_of: :parent_supports

  validates :supporting_part, presence: true
  validates :supported_part, presence: true, uniqueness: { scope: :supporting_part_id }

end
