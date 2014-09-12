class Collaborator < ActiveRecord::Base

  sortable

  belongs_to :parent, polymorphic: true
  belongs_to :user, inverse_of: :collaborators

  validates :parent, presence: true
  validates :user, presence: true, uniqueness: { scope: [:parent_id, :parent_type] }

  scope :authors, lambda { where(is_author: true) }
  scope :copyright_holders, lambda { where(is_copyright_holder: true) }

  delegate_access_control_to :parent

  delegate :name, to: :user

end
