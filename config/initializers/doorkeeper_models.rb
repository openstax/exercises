require_relative 'doorkeeper'

Doorkeeper::Application.class_exec do
  belongs_to :owner, polymorphic: true

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
