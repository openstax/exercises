class ListNesting < ActiveRecord::Base

  sortable

  belongs_to :parent_list, class_name: 'List'
  belongs_to :child_list, class_name: 'List'

  validates :parent_list, presence: true
  validates :child_list, presence: true, uniqueness: true

end
