class CopyrightHolder < ApplicationRecord

  sortable_belongs_to :publication, inverse_of: :copyright_holders

  belongs_to :user

  validates :user, uniqueness: { scope: :publication_id }

  delegate :name, :delegations_as_delegator, :delegations_as_delegate, to: :user

end
