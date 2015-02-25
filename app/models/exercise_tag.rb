class ExerciseTag < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :tag

  validates :exercise, presence: true
  validates :tag, presence: true, uniqueness: { scope: :exercise_id }
end
