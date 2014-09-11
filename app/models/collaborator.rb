class Collaborator < ActiveRecord::Base

  sortable

  belongs_to :parent, polymorphic: true
  belongs_to :user, inverse_of: :collaborators

  validates :parent, presence: true
  validates :user, presence: true, uniqueness: {
              scope: [:parent_id, :parent_type] }

  delegate_access_control_to :parent

end
