class Collaborator < ActiveRecord::Base

  sortable [:collaborable_id, :collaborable_type]
  belongs_to :collaborable, polymorphic: true
  belongs_to :user, inverse_of: :collaborators

  has_one :author_request, inverse_of: :collaborator, dependent: :destroy
  has_one :copyright_holder_request, inverse_of: :collaborator, dependent: :destroy

  validates :collaborable, presence: true
  validates :user, presence: true, uniqueness: {
              scope: [:collaborable_id, :collaborable_type] }

  before_destroy :no_roles

  protected

  def no_roles
    return unless is_author || is_copyright_holder
    errors.add(:base, 'cannot be removed while it has roles')
    false
  end

end
