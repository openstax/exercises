class Author < ApplicationRecord

  sortable_belongs_to :publication, inverse_of: :authors

  belongs_to :user

  validates :user, uniqueness: { scope: :publication_id }

  delegate :name, to: :user

end
