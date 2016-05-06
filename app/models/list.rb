class List < ActiveRecord::Base

  publishable

  has_one :parent_list_nesting, class_name: 'ListNesting',
                                inverse_of: :child_list

  has_many :child_list_nestings, class_name: 'ListNesting',
                                 inverse_of: :parent_list

  has_many :list_owners, dependent: :destroy
  has_many :list_editors, dependent: :destroy
  has_many :list_readers, dependent: :destroy

  sortable_has_many :list_exercises, dependent: :destroy, inverse_of: :list
  sortable_has_many :list_vocab_terms, dependent: :destroy, inverse_of: :list

  validates :name, presence: true

end
