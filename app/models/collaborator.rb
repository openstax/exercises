class Collaborator < ActiveRecord::Base

  sortable

  belongs_to :publication, inverse_of: :collaborators
  belongs_to :user, inverse_of: :collaborators

  validates :publication, presence: true
  validates :user, presence: true, uniqueness: { scope: :publication_id }

  scope :authors, lambda { where(is_author: true) }
  scope :copyright_holders, lambda { where(is_copyright_holder: true) }

  delegate_access_control_to :publication

  delegate :name, to: :user

end
