class ListPublicationGroup < ActiveRecord::Base

  sortable_belongs_to :list, inverse_of: :list_publication_groups
  belongs_to :publication_group, inverse_of: :list_publication_groups

  validates :list, presence: true
  validates :publication_group, presence: true, uniqueness: { scope: :list_id }

end