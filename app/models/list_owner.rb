class ListOwner < ActiveRecord::Base

  belongs_to :list, inverse_of: :list_owners
  belongs_to :owner, polymorphic: true

  validates :list, presence: true
  validates :owner, presence: true, uniqueness: { scope: :list_id }

end
