class CreateBlankExercise

  lev_routine

protected

  def exec
    exercise = Exercise.new
    exercise.license = License.where{short_name == 'CC BY 3.0'}.first
    exercise.save

    outputs[:exercise] = exercise
    transfer_errors_from(exercise, {type: :verbatim})
  end

end