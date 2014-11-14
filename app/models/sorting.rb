class Sorting < ActiveRecord::Base

  belongs_to :user
  belongs_to :sortable, polymorphic: true

  validates :user, presence: true
  validates :sortable, presence: true, uniqueness: { scope: :user_id }
  validates :position, presence: true, numericality: true,
                       uniqueness: { scope: [:user_id, :sortable_type] }

end
