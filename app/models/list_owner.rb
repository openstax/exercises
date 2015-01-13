class ListOwner < ActiveRecord::Base

  belongs_to :list
  belongs_to :owner, polymorphic: true

  validates :list, presence: true,
                   uniqueness: { scope: [:owner_type, :owner_id] }
  validates :owner, presence: true

end
