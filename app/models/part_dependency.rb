class PartDependency < ActiveRecord::Base

  belongs_to :parent_part, class_name: 'Part', inverse_of: :child_dependencies
  belongs_to :dependent_part, class_name: 'Part', inverse_of: :parent_dependencies

  validates :parent_part, presence: true
  validates :dependent_part, presence: true, uniqueness: { scope: :parent_part_id }

end
