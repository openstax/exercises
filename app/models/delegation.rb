class Delegation < ApplicationRecord

  belongs_to :delegator, class_name: User.name, inverse_of: :delegations_as_delegator
  belongs_to :delegate,  polymorphic: true, inverse_of: :delegations_as_delegate

  validates :delegate_id, uniqueness: { scope: [ :delegator_id, :delegate_type ] }
  validate :different_users

  def delegator_name
    delegator&.name
  end

  def delegate_name
    delegate&.name
  end

  protected

  def different_users
    return if delegate_type != User.name || delegator_id != delegate_id
    errors.add :delegate, 'must not be the same user as the Delegator'
    throw(:abort)
  end

end
