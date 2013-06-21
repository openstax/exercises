class ExerciseDerivation < ActiveRecord::Base
  attr_accessible :derived, :deriver_id, :source_exercise_id
end
