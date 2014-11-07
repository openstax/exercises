class CopyrightHolder < ActiveRecord::Base

  sortable

  belongs_to :publication
  belongs_to :user

  validates :publication, presence: true
  validates :user, presence: true, uniqueness: { scope: :publication_id }

  delegate_access_control_to :publication

  delegate :name, to: :user

end
