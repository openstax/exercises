class List < ApplicationRecord

  publishable

  has_one :parent_list_nesting, class_name: 'ListNesting', inverse_of: :child_list

  has_many :child_list_nestings, class_name: 'ListNesting', inverse_of: :parent_list

  has_many :list_owners, dependent: :destroy, inverse_of: :list
  has_many :list_editors, dependent: :destroy, inverse_of: :list
  has_many :list_readers, dependent: :destroy, inverse_of: :list

  sortable_has_many :list_publication_groups, dependent: :destroy, inverse_of: :list
  has_many :publication_groups, through: :list_publication_groups

  validates :name, presence: true

  def has_publication_group?(publication_group)
    list_publication_groups.any?{ |lpg| lpg.publication_group == publication_group }
  end

  def has_owner?(user)
    list_owners.any?{ |lo| lo.owner == user }
  end

  def has_editor?(user)
    list_editors.any?{ |le| le.editor == user }
  end

  def has_reader?(user)
    list_readers.any?{ |lr| lr.reader == user }
  end

  def has_member?(user)
    has_owner?(user) || has_editor?(user) || has_reader?(user)
  end

  def has_read_permission?(user)
    has_member?(user) || publication.has_read_permission?(user)
  end

  def has_write_permission?(user)
    has_owner?(user) || publication.has_write_permission?(user)
  end

end
