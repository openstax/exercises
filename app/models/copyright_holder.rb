class CopyrightHolder < ActiveRecord::Base

  sortable_belongs_to :publication, inverse_of: :copyright_holders

  belongs_to :user

  validates :publication, presence: true
  validates :user, presence: true, uniqueness: { scope: :publication_id }

  delegate :name, to: :user

end
