class Editor < ActiveRecord::Base

  sortable_belongs_to :publication

  belongs_to :user

  validates :publication, presence: true
  validates :user, presence: true, uniqueness: { scope: :publication_id }

  delegate :name, to: :user

end
