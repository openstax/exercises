class CreateListExercise

  lev_routine

protected

  def exec(list, exercise)
    outputs[:list_exercise] = ListExercise.create(:list => list, :exercise => exercise)
    transfer_errors_from(outputs[:list_exercise], {type: :verbatim})
  end

end