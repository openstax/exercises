require_relative 'doorkeeper'

Doorkeeper::Application.class_exec do
  belongs_to :owner, polymorphic: true

  has_one :trusted_application, dependent: :destroy

  validates :owner, presence: true

  scope :trusted, lambda { joins(:trusted_application) }
  scope :not_trusted, lambda { joins{trusted_application.outer}
                               .where(trusted_application: {id: nil}) }

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
