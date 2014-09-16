class Author < ActiveRecord::Base

  sortable

  belongs_to :publication, inverse_of: :authors
  belongs_to :user, inverse_of: :authors

  validates :publication, presence: true
  validates :user, presence: true, uniqueness: { scope: :publication_id }

  delegate_access_control_to :publication

  delegate :name, to: :user

end
