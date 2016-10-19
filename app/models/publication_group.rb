class PublicationGroup < ActiveRecord::Base

  has_many :publications, dependent: :destroy, inverse_of: :publication_group

  has_many :list_publication_groups, dependent: :destroy

  validates :publishable_type, presence: true
  validates :uuid, presence: true, uniqueness: true
  validates :number, presence: true, uniqueness: { scope: :publishable_type }

  before_validation :assign_uuid_and_number, on: :create

  default_scope { order(:number) }

  alias_attribute :group_uuid, :uuid

  def readonly?
    !new_record?
  end

  protected

  def assign_uuid_and_number
    self.uuid ||= SecureRandom.uuid
    self.number ||= (PublicationGroup.where(publishable_type: publishable_type)
                                     .maximum(:number) || 0) + 1
  end

end
