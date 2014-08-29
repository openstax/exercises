class ListEditor < ActiveRecord::Base

  belongs_to :list, inverse_of: :list_owners
  belongs_to :editor, polymorphic: true

  validates :list, presence: true
  validates :editor, presence: true, uniqueness: { scope: :list_id }

  delegate_access_control_to :list

end
