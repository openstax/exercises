class Editor < ActiveRecord::Base

  sortable

  belongs_to :publication, inverse_of: :editors
  belongs_to :user, inverse_of: :editors

  validates :publication, presence: true
  validates :user, presence: true, uniqueness: { scope: :publication_id }

  delegate_access_control_to :publication

  delegate :name, to: :user

end
