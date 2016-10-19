class List < ActiveRecord::Base

  publishable

  has_one :parent_list_nesting, class_name: 'ListNesting', inverse_of: :child_list

  has_many :child_list_nestings, class_name: 'ListNesting', inverse_of: :parent_list

  has_many :list_owners, dependent: :destroy, inverse_of: :list
  has_many :list_editors, dependent: :destroy, inverse_of: :list
  has_many :list_readers, dependent: :destroy, inverse_of: :list

  sortable_has_many :list_publication_groups, dependent: :destroy, inverse_of: :list
  has_many :publication_groups, through: :list_publication_groups

  validates :name, presence: true

end
