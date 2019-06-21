require_relative 'doorkeeper'

Doorkeeper::Application.class_exec do
  belongs_to :owner, polymorphic: true

  has_one :trusted_application, dependent: :destroy

  validates :owner, presence: true

  scope :trusted, -> do
    ta = TrustedApplication.arel_table
    ap = arel_table
    where(TrustedApplication.where(ta[:application_id].eq(ap[:id])).arel.exists)
  end
  scope :not_trusted, -> do
    ta = TrustedApplication.arel_table
    ap = arel_table
    where.not(TrustedApplication.where(ta[:application_id].eq(ap[:id])).arel.exists)
  end

  def is_human?
    false
  end

  def is_application?
    true
  end

  def is_anonymous?
    false
  end

  def is_administrator?
    false
  end
end
