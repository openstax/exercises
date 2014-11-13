class ListEditor < ActiveRecord::Base

  sortable

  belongs_to :list
  belongs_to :editor, polymorphic: true

  validates :list, presence: true
  validates :editor, presence: true, uniqueness: { scope: :list_id }

end
