class ExerciseTag < ApplicationRecord
  belongs_to :exercise
  belongs_to :tag

  validates :tag, uniqueness: { scope: :exercise_id }
end
