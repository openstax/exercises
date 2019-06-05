class ListReader < ApplicationRecord

  belongs_to :list, inverse_of: :list_readers
  belongs_to :reader, polymorphic: true

  validates :list, uniqueness: { scope: [:reader_type, :reader_id] }

end
