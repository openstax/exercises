class ListNesting < ApplicationRecord

  belongs_to :parent_list, class_name: 'List', inverse_of: :child_list_nestings
  belongs_to :child_list, class_name: 'List', inverse_of: :parent_list_nesting

  validates :child_list, uniqueness: true

end
