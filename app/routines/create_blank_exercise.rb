class CreateBlankExercise

  lev_routine
  uses_routine CreateListExercise
  uses_routine CreateBlankPart

protected

  def exec(author)
    exercise = Exercise.new

    # Default to a CC-BY license
    exercise.license = License.where{short_name == 'CC BY 3.0'}.first
    exercise.background = Content.new
    
    # Save it
    exercise.save

    # Add a blank part
    run(CreateBlankPart, exercise)

    # Put it on the author's default list
    run(CreateListExercise, author.default_list, exercise)

    outputs[:exercise] = exercise
    transfer_errors_from(exercise, {type: :verbatim})
  end

end