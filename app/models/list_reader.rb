class ListReader < ActiveRecord::Base

  belongs_to :list, inverse_of: :list_readers
  belongs_to :reader, polymorphic: true

  validates :list, presence: true, uniqueness: { scope: [:reader_type, :reader_id] }
  validates :reader, presence: true

end
