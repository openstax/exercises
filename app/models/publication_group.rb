class PublicationGroup < ActiveRecord::Base

  has_many :publications, dependent: :destroy, inverse_of: :publication_group, autosave: true

  has_many :list_publication_groups, dependent: :destroy

  has_many :vocab_distractors, dependent: :destroy

  validates :publishable_type, presence: true
  validates :uuid, presence: true, uniqueness: true
  validates :number, presence: true, uniqueness: { scope: :publishable_type },
                     numericality: { only_integer: true, greater_than: 0 }
  validates :latest_version, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :latest_published_version,
            numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  validates :nickname, uniqueness: { allow_nil: true }

  before_validation :assign_uuid_and_number, on: :create
  before_validation :set_nickname_to_nil_if_blank
  default_scope { order(:number) }

  # The column in this record is called uuid, but everywhere else we refer to it as group_uuid
  alias_attribute :group_uuid, :uuid

  def assign_uuid_and_number
    self.uuid ||= SecureRandom.uuid
    self.number ||= (
      PublicationGroup.where(publishable_type: publishable_type).maximum(:number) || 0
    ) + 1
  end

  def set_nickname_to_nil_if_blank
    # this forces DB column value to be null not ''
    self.nickname = nil if nickname.blank?
  end

end
