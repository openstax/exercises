class List < ActiveRecord::Base

  publishable
  sort_domain

  has_one :parent_list_nesting, class_name: 'ListNesting'
  has_one :parent_list, through: :parent_list_nesting

  has_many :child_list_nestings, class_name: 'ListNesting'
  has_many :child_lists, through: :child_list_nestings

  has_many :list_owners, dependent: :destroy
  has_many :list_editors, dependent: :destroy
  has_many :list_readers, dependent: :destroy

  has_many :list_exercises, dependent: :destroy
  has_many :exercises, through: :list_exercises

  validates :name, presence: true

end
