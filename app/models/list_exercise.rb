class ListExercise < ActiveRecord::Base

  sortable

  belongs_to :list
  belongs_to :exercise

  validates :list, presence: true
  validates :exercise, presence: true, uniqueness: { scope: :list_id }

end
