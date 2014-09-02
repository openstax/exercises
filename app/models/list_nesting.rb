class ListNesting < ActiveRecord::Base

  sortable :parent_list

  belongs_to :parent_list, class_name: 'List', inverse_of: :child_list_nestings
  belongs_to :child_list, class_name: 'List', inverse_of: :parent_list_nesting

  validates :parent_list, presence: true
  validates :child_list, presence: true, uniqueness: true

  delegate_access_control_to :list

end
