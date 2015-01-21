class ListReader < ActiveRecord::Base

  belongs_to :list
  belongs_to :reader, polymorphic: true

  validates :list, presence: true,
                   uniqueness: { scope: [:reader_type, :reader_id] }
  validates :reader, presence: true

end
