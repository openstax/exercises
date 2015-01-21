class ListExercise < ActiveRecord::Base

  sortable_belongs_to :list, inverse_of: :list_exercises
  belongs_to :exercise

  validates :list, presence: true
  validates :exercise, presence: true, uniqueness: { scope: :list_id }

end
