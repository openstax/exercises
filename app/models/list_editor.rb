class ListEditor < ActiveRecord::Base

  belongs_to :list, inverse_of: :list_editors
  belongs_to :editor, polymorphic: true

  validates :list, presence: true, uniqueness: { scope: [:editor_type, :editor_id] }
  validates :editor, presence: true

end
