class ListOwner < ApplicationRecord

  belongs_to :list, inverse_of: :list_owners
  belongs_to :owner, polymorphic: true

  validates :list, presence: true, uniqueness: { scope: [:owner_type, :owner_id] }
  validates :owner, presence: true

end
