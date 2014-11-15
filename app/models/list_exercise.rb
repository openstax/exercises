class ListExercise < ActiveRecord::Base

  sortable container: :list, records: :exercises, scope: :list_id

  belongs_to :list
  belongs_to :exercise

  validates :list, presence: true
  validates :exercise, presence: true, uniqueness: { scope: :list_id }

end
