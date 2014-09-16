class CopyrightHolder < ActiveRecord::Base

  sortable

  belongs_to :publication, inverse_of: :copyright_holders
  belongs_to :user, inverse_of: :copyright_holders

  validates :publication, presence: true
  validates :user, presence: true, uniqueness: { scope: :publication_id }

  delegate_access_control_to :publication

  delegate :name, to: :user

end
