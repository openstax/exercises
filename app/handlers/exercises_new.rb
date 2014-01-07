class ExercisesNew

  lev_handler

  uses_routine CreateBlankExercise,
               translations: { outputs: { type: :verbatim } }

protected

  def authorized?
    true
  end

  def handle
    run(CreateBlankExercise, caller)
  end

end