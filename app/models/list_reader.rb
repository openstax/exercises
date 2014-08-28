class ListReader < ActiveRecord::Base

  belongs_to :list, inverse_of: :list_owners
  belongs_to :reader, polymorphic: true

  validates :list, presence: true
  validates :reader, presence: true, uniqueness: { scope: :list_id }

end
