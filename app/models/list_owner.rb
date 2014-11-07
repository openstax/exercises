class ListOwner < ActiveRecord::Base

  sortable

  belongs_to :list
  belongs_to :owner, polymorphic: true

  validates :list, presence: true
  validates :owner, presence: true, uniqueness: { scope: :list_id }

  delegate_access_control_to :list

end
