class Collaborator < ActiveRecord::Base

  sortable :collaborable

  belongs_to :parent, polymorphic: true
  belongs_to :user, inverse_of: :collaborators

  has_one :author_request, inverse_of: :collaborator, dependent: :destroy
  has_one :copyright_holder_request, inverse_of: :collaborator, dependent: :destroy

  validates :parent, presence: true
  validates :user, presence: true, uniqueness: {
              scope: [:collaborable_id, :collaborable_type] }

  before_destroy :no_roles

  delegate_access_control_to :parent

  protected

  def no_roles
    return unless is_author || is_copyright_holder
    errors.add(:base, 'cannot be removed while they have roles')
    false
  end

end
