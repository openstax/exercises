class ListEditor < ApplicationRecord

  belongs_to :list, inverse_of: :list_editors
  belongs_to :editor, polymorphic: true

  validates :list, uniqueness: { scope: [:editor_type, :editor_id] }

end
