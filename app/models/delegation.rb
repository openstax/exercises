class Delegation < ApplicationRecord

  belongs_to :delegator, class_name: 'User', inverse_of: :delegations_as_delegator
  belongs_to :delegate,  class_name: 'User', inverse_of: :delegations_as_delegate

  validates :delegate, uniqueness: { scope: :delegator_id }
  validate :different_users

  def can_read
    true
  end

  def delegator_name
    delegator&.name
  end

  def delegate_name
    delegate&.name
  end

  protected

  def different_users
    return if delegator.nil? || delegator != delegate
    errors.add :delegator, 'must not be the same user as Delegate'
    throw(:abort)
  end

end
