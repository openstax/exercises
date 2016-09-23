class PublicationGroup < ActiveRecord::Base

  has_many :publications, dependent: :destroy, inverse_of: :publication_group

  validates :publishable_type, presence: true
  validates :number, presence: true, uniqueness: { scope: :publishable_type }
  validates :uuid, presence: true, uniqueness: true

  before_validation :assign_number_and_uuid, on: :create

  def readonly?
    !new_record?
  end

  protected

  def assign_number_and_uuid
    self.number ||= (PublicationGroup.where(publishable_type: publishable_type)
                                     .maximum(:number) || 0) + 1
    self.uuid ||= SecureRandom.uuid
  end

end
