class ListOwner < ApplicationRecord

  belongs_to :list, inverse_of: :list_owners
  belongs_to :owner, polymorphic: true

  validates :list, uniqueness: { scope: [:owner_type, :owner_id] }

end
