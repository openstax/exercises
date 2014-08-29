class List < ActiveRecord::Base

  publishable
  has_collaborators

  has_one :parent_list_nesting, class_name: 'ListNesting', inverse_of: :child_list
  has_one :parent_list, through: :parent_list_nesting

  has_many :child_list_nestings, class_name: 'ListNesting', inverse_of: :parent_list
  has_many :child_lists, through: :child_list_nestings

  has_many :list_owners, dependent: :destroy, inverse_of: :list
  has_many :list_editors, dependent: :destroy, inverse_of: :list
  has_many :list_readers, dependent: :destroy, inverse_of: :list

  has_many :list_exercises, dependent: :destroy, inverse_of: :list
  has_many :exercises, through: :list_exercises

  validates :name, presence: true

end
