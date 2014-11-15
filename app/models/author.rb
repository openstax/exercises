class Author < ActiveRecord::Base

  sortable container: :publication, records: :authors, scope: :publication_id

  belongs_to :publication
  belongs_to :user

  validates :publication, presence: true
  validates :user, presence: true, uniqueness: { scope: :publication_id }

  delegate :name, to: :user

end
