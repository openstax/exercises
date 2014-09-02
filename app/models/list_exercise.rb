class ListExercise < ActiveRecord::Base

  sortable :list

  belongs_to :list, :inverse_of => :list_exercises
  belongs_to :exercise, :inverse_of => :list_exercises

  validates :list, presence: true
  validates :exercise, presence: true, uniqueness: { scope: :list_id }

end
