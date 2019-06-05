class ListPublicationGroup < ApplicationRecord

  sortable_belongs_to :list, inverse_of: :list_publication_groups
  belongs_to :publication_group, inverse_of: :list_publication_groups

  validates :publication_group, uniqueness: { scope: :list_id }

end
