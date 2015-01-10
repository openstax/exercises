class ListNesting < ActiveRecord::Base

  belongs_to :parent_list, class_name: 'List', inverse_of: :child_list_nestings
  belongs_to :child_list, class_name: 'List', inverse_of: :parent_list_nestings

  validates :parent_list, presence: true
  validates :child_list, presence: true, uniqueness: true

end
