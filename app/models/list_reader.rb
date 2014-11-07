class ListReader < ActiveRecord::Base

  sortable

  belongs_to :list
  belongs_to :reader, polymorphic: true

  validates :list, presence: true
  validates :reader, presence: true, uniqueness: { scope: :list_id }

  delegate_access_control_to :list

end
