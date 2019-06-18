class Delegation < ApplicationRecord

  belongs_to :delegator, class_name: 'User', inverse_of: :delegations_as_delegator
  belongs_to :delegate,  class_name: 'User', inverse_of: :delegations_as_delegate

  validates :delegate, uniqueness: { scope: :delegator_id }

end
